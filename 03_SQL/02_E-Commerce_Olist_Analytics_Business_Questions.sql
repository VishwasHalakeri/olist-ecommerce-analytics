USE ecommerce_olist_analytics;

# Sales Analytics

# Which months experienced the highest month-over-month revenue growth?
WITH monthly_revenue AS
(
    SELECT DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS order_month, SUM(oi.price) AS monthly_revenue
	FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
	WHERE order_status='delivered'
	GROUP BY DATE_FORMAT(order_purchase_timestamp,'%Y-%m')
),

growth AS
(
    SELECT order_month, monthly_revenue, LAG(monthly_revenue)
		OVER(ORDER BY order_month) previous_month_revenue
	FROM monthly_revenue
)

SELECT order_month, ROUND(monthly_revenue,2) AS monthly_revenue, ROUND(previous_month_revenue,2) previous_month,
	ROUND(
        (
            monthly_revenue-previous_month_revenue
        )/
        previous_month_revenue*100,
        2
    ) AS growth_percentage
FROM growth
WHERE previous_month_revenue IS NOT NULL
ORDER BY growth_percentage DESC;


# Which product categories contributed the largest percentage of total marketplace revenue?
WITH category_revenue AS
(
SELECT pct.product_category_name_english, SUM(oi.price) revenue
FROM order_items oi JOIN products p ON oi.product_id=p.product_id
LEFT JOIN category_translation pct ON p.product_category_name=pct.product_category_name
GROUP BY pct.product_category_name_english
)

SELECT product_category_name_english, ROUND(revenue,2) revenue,
ROUND(
revenue/
SUM(revenue) OVER()*100,
2
) revenue_percentage
FROM category_revenue
ORDER BY revenue DESC;

    
# Which product categories consistently ranked among the top five revenue-generating categories each month?
WITH monthly_category_revenue AS
(
SELECT DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') month, pct.product_category_name_english, SUM(oi.price) revenue
FROM orders o JOIN order_items oi ON o.order_id=oi.order_id
JOIN products p ON oi.product_id=p.product_id
LEFT JOIN category_translation pct ON p.product_category_name=pct.product_category_name
WHERE o.order_status='delivered'
GROUP BY month, pct.product_category_name_english
),

ranked_categories AS
(
SELECT month, product_category_name_english, revenue,
DENSE_RANK() OVER
(
PARTITION BY month
ORDER BY revenue DESC
) category_rank
FROM monthly_category_revenue
)

SELECT * FROM ranked_categories
WHERE category_rank<=5
ORDER BY month, 
category_rank;    


# Which months generated revenue above the overall monthly average?
WITH monthly_revenue AS
(
SELECT DATE_FORMAT(order_purchase_timestamp,'%Y-%m') month, SUM(oi.price) revenue
FROM orders o JOIN order_items oi ON o.order_id=oi.order_id
WHERE order_status='delivered'
GROUP BY month
)

SELECT month, ROUND(revenue,2) revenue
FROM monthly_revenue
WHERE revenue> (SELECT AVG(revenue) FROM monthly_revenue)
ORDER BY revenue DESC;


# Which top 20% of customers contribute the highest percentage of marketplace revenue?
WITH customer_revenue AS
(
SELECT c.customer_unique_id, ROUND(SUM(oi.price),2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status='delivered'
GROUP BY c.customer_unique_id
),

ranked_customers AS
(
SELECT customer_unique_id, revenue,
SUM(revenue)
OVER(ORDER BY revenue DESC)
AS cumulative_revenue,
SUM(revenue)
OVER()
AS total_revenue
FROM customer_revenue
)

SELECT customer_unique_id, revenue,
ROUND(
        cumulative_revenue/
        total_revenue*100,
        2
    ) AS cumulative_percentage
FROM ranked_customers
WHERE cumulative_revenue/total_revenue<=0.80;


# Customer Analytics

# Which customers generated the highest lifetime revenue?
SELECT c.customer_unique_id, ROUND(SUM(oi.price),2) AS lifetime_revenue, COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(AVG(oi.price),2) AS average_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY lifetime_revenue DESC
LIMIT 20;


# Which customers rank highest in lifetime revenue within each state?
WITH customer_revenue AS
(
SELECT c.customer_state, c.customer_unique_id, ROUND(SUM(oi.price),2) AS lifetime_revenue, COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status='delivered'
GROUP BY c.customer_state,
c.customer_unique_id
)

SELECT customer_state, customer_unique_id, lifetime_revenue, total_orders,
DENSE_RANK() OVER
    (
        PARTITION BY customer_state
        ORDER BY lifetime_revenue DESC
    ) AS customer_rank
FROM customer_revenue
ORDER BY customer_state,
customer_rank;


# Which customers contribute the highest percentage of revenue within their state?
WITH customer_revenue AS
(
SELECT c.customer_state, c.customer_unique_id, SUM(oi.price) revenue
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
GROUP BY c.customer_state,
c.customer_unique_id
)

SELECT customer_state, customer_unique_id, ROUND(revenue,2) revenue, 
ROUND(
revenue/
SUM(revenue)
OVER(PARTITION BY customer_state)
*100,
2
) contribution_percentage
FROM customer_revenue
ORDER BY customer_state,
contribution_percentage DESC;


# What is the average number of days between purchases for repeat customers?
WITH purchase_history AS
(
SELECT c.customer_unique_id, o.order_purchase_timestamp, 
LAG(o.order_purchase_timestamp)
OVER
(
PARTITION BY c.customer_unique_id
ORDER BY o.order_purchase_timestamp
) AS previous_purchase
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
WHERE o.order_status='delivered'
),

purchase_gap AS
(
SELECT customer_unique_id, DATEDIFF( order_purchase_timestamp, previous_purchase) AS purchase_gap_days
FROM purchase_history
WHERE previous_purchase IS NOT NULL
)

SELECT ROUND(AVG(purchase_gap_days), 2) AS average_days_between_purchases
FROM purchase_gap;


# Which customer value segment contributes the largest share of marketplace revenue?
WITH customer_revenue AS
(
SELECT c.customer_unique_id, SUM(oi.price) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status='delivered'
GROUP BY c.customer_unique_id
),

customer_segments AS
(
SELECT customer_unique_id, revenue,
CASE
	WHEN revenue >= 1000 THEN 'High Value'
	WHEN revenue BETWEEN 500 AND 999.99 THEN 'Medium Value'
	ELSE 'Low Value'
	END AS customer_segment
FROM customer_revenue
)

SELECT customer_segment, ROUND(SUM(revenue),2) AS segment_revenue,
ROUND(
        SUM(revenue)/
        SUM(SUM(revenue)) OVER()*100,
        2
    ) AS revenue_percentage
FROM customer_segments
GROUP BY customer_segment
ORDER BY segment_revenue DESC;


# Which customer segment has the highest purchase frequency and average order value?
WITH customer_metrics AS
(
SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS total_orders, SUM(oi.price) AS total_revenue, AVG(oi.price) AS average_order_value
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
GROUP BY c.customer_unique_id
),

customer_segments AS
(
SELECT *,
	CASE
		WHEN total_revenue>=1000 THEN 'High Value'
		WHEN total_revenue>=500 THEN 'Medium Value'
		ELSE 'Low Value'
        END AS customer_segment
FROM customer_metrics
)

SELECT customer_segment, ROUND(AVG(total_orders),2) AS avg_purchase_frequency, ROUND(AVG(average_order_value),2) AS avg_order_value, COUNT(*) AS total_customers
FROM customer_segments
GROUP BY customer_segment
ORDER BY avg_order_value DESC;


# Which states have the highest concentration of high-value customers?
WITH customer_revenue AS
(
SELECT c.customer_unique_id, c.customer_state, SUM(oi.price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
GROUP BY c.customer_unique_id,
c.customer_state
),

customer_segments AS
(
SELECT *,
	CASE
		WHEN total_revenue>=1000 THEN 'High Value'
		WHEN total_revenue>=500 THEN 'Medium Value'
		ELSE 'Low Value'
        END AS customer_segment
FROM customer_revenue
)

SELECT customer_state, COUNT(*) AS high_value_customers,
ROUND(
        COUNT(*)*100.0/
        SUM(COUNT(*)) OVER(),
        2
    ) AS percentage_of_high_value_customers
FROM customer_segments
WHERE customer_segment='High Value'
GROUP BY customer_state
ORDER BY high_value_customers DESC;


# Product Analytics

# Which product categories have the highest average revenue per product?
WITH product_revenue AS
(
SELECT p.product_id, pct.product_category_name_english AS category, SUM(oi.price) revenue
FROM products p
JOIN order_items oi ON p.product_id=oi.product_id
LEFT JOIN category_translation pct ON p.product_category_name=pct.product_category_name
GROUP BY p.product_id,
category
)

SELECT category, COUNT(product_id) total_products, ROUND(AVG(revenue),2) AS avg_revenue_per_product
FROM product_revenue
GROUP BY category
ORDER BY avg_revenue_per_product DESC;


# Which products have unusually high freight costs relative to their selling price?
SELECT oi.product_id, ROUND(AVG(price),2) avg_price, ROUND(AVG(freight_value),2) avg_freight,
ROUND(AVG(freight_value)/AVG(price)*100,2) freight_percentage
FROM order_items oi
GROUP BY oi.product_id
HAVING AVG(freight_value)/AVG(price)>.30
ORDER BY freight_percentage DESC;


# Which products consistently generated revenue across multiple months?
WITH monthly_sales AS
(
SELECT oi.product_id, DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') month
FROM orders o
JOIN order_items oi ON o.order_id=oi.order_id
WHERE order_status='delivered'
GROUP BY oi.product_id,
month
)

SELECT product_id, COUNT(month) active_months
FROM monthly_sales
GROUP BY product_id
HAVING COUNT(month)>=6
ORDER BY active_months DESC;


# Which product categories are most dependent on their top-selling products?
WITH product_revenue AS
(
SELECT pct.product_category_name_english AS category, p.product_id, SUM(oi.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN category_translation pct ON p.product_category_name =pct.product_category_name
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status='delivered'
GROUP BY category, 
p.product_id
),

ranked_products AS
(
SELECT category, product_id, revenue, 
ROW_NUMBER() 
OVER(
PARTITION BY category
ORDER BY revenue DESC
) product_rank,
SUM(revenue)
OVER(
PARTITION BY category
) category_revenue
FROM product_revenue
)

SELECT category, SUM(revenue) top3_revenue, MAX(category_revenue) total_category_revenue, ROUND(SUM(revenue)/MAX(category_revenue)*100,2) concentration_percentage
FROM ranked_products
WHERE product_rank<=3
GROUP BY category
ORDER BY concentration_percentage DESC;


# Logistic & Delivery Analytics

# Which customer states have the longest average delivery time?
SELECT c.customer_state, COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status='delivered'
AND
o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;


# Which sellers consistently deliver orders faster than the marketplace average?
WITH seller_delivery AS
(
SELECT oi.seller_id, AVG(DATEDIFF(o.order_delivered_customer_date,o.order_purchase_timestamp)) avg_delivery_days, COUNT(DISTINCT o.order_id) total_orders
FROM orders o
JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
AND
o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
),

market_average AS
(
SELECT AVG(avg_delivery_days) AS marketplace_average
FROM seller_delivery
)

SELECT sd.seller_id, ROUND(sd.avg_delivery_days,2) AS avg_delivery_days, sd.total_orders
FROM seller_delivery sd
CROSS JOIN market_average ma
WHERE sd.avg_delivery_days< ma.marketplace_average
AND
sd.total_orders>=20
ORDER BY avg_delivery_days ASC;


# Which customer states have the highest delivery reliability based on on-time delivery performance?
WITH state_delivery AS
(
SELECT c.customer_state, COUNT(*) AS total_deliveries,
SUM(
	CASE
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1
		ELSE 0
		END
		) AS on_time_deliveries
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status='delivered'
GROUP BY c.customer_state
)

SELECT customer_state, total_deliveries, on_time_deliveries, ROUND(on_time_deliveries/total_deliveries*100, 2) AS on_time_percentage,
DENSE_RANK()
OVER(
	ORDER BY on_time_deliveries/total_deliveries DESC
    ) logistics_rank
FROM state_delivery
ORDER BY logistics_rank;


# Seller Analytics

# Which sellers generate the highest average revenue per delivered order?
SELECT s.seller_id, ROUND(SUM(oi.price),2) AS total_revenue, COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(
        SUM(oi.price)/
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_revenue_per_order
FROM sellers s
JOIN order_items oi ON s.seller_id=oi.seller_id
JOIN orders o ON oi.order_id=o.order_id
WHERE o.order_status='delivered'
GROUP BY s.seller_id
HAVING COUNT(DISTINCT o.order_id)>=20
ORDER BY average_revenue_per_order DESC;


# Which sellers consistently generated revenue across multiple months?
WITH seller_months AS
(
SELECT seller_id, DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS sales_month
FROM order_items oi
JOIN orders o ON oi.order_id=o.order_id
WHERE o.order_status='delivered'
GROUP BY seller_id,
sales_month
)

SELECT seller_id, COUNT(DISTINCT sales_month) AS active_months
FROM seller_months
GROUP BY seller_id
HAVING COUNT(DISTINCT sales_month)>=6
ORDER BY active_months DESC;


# Which sellers generate the highest revenue relative to the number of products they sell?
SELECT s.seller_id, COUNT(DISTINCT oi.product_id) AS total_products, SUM(oi.price) AS total_revenue,
ROUND(
		SUM(oi.price) /
		COUNT(DISTINCT oi.product_id),
            2
        ) AS revenue_per_product
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id
ORDER BY revenue_per_product DESC
LIMIT 20;


# Which sellers consistently receive high customer ratings while maintaining strong sales?
WITH seller_performance AS 
(
SELECT s.seller_id, ROUND(SUM(oi.price),2) AS total_revenue, ROUND(AVG(r.review_score),2) AS average_rating, COUNT(DISTINCT o.order_id) AS total_orders
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id
)

SELECT seller_id, total_revenue, average_rating, total_orders,
DENSE_RANK() OVER(
					ORDER BY average_rating DESC
				) AS rating_rank
FROM seller_performance
ORDER BY rating_rank;


# Customer Experience Analytics

# Which product categories receive the highest and lowest customer satisfaction after considering review volume?
WITH category_reviews AS
(
SELECT pct.product_category_name_english AS category, COUNT(r.review_id) AS total_reviews, ROUND(AVG(r.review_score),2) AS average_rating
FROM orders o
JOIN order_items oi ON o.order_id=oi.order_id
JOIN products p ON oi.product_id=p.product_id
LEFT JOIN category_translation pct ON p.product_category_name=pct.product_category_name
JOIN reviews r ON o.order_id=r.order_id
WHERE o.order_status='delivered'
GROUP BY category
HAVING COUNT(r.review_id)>=50
)

SELECT category, total_reviews, average_rating,
DENSE_RANK()
OVER(
ORDER BY average_rating DESC
) satisfaction_rank
FROM category_reviews
ORDER BY satisfaction_rank;


# How does delivery performance influence customer satisfaction?
SELECT
CASE
	WHEN order_delivered_customer_date<=order_estimated_delivery_date THEN 'On Time'
	ELSE 'Delayed'
	END delivery_status,
COUNT(*) total_orders,
ROUND(AVG(review_score),2) average_rating
FROM orders o
JOIN reviews r
ON o.order_id=r.order_id
WHERE o.order_status='delivered'
GROUP BY delivery_status;


# Which sellers receive poor customer ratings despite strong logistics performance?
WITH seller_metrics AS
(
SELECT s.seller_id, ROUND(AVG(r.review_score),2) AS avg_rating, 
ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)),2) AS avg_delivery_days,
ROUND(
		SUM(
			CASE
				WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1
				ELSE 0
                END
            ) * 100.0 /
            COUNT(DISTINCT o.order_id),
            2
        ) AS on_time_percentage,
COUNT(DISTINCT o.order_id) AS total_orders
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status='delivered'
GROUP BY s.seller_id
),

benchmark AS
(
SELECT AVG(avg_rating) avg_rating, AVG(on_time_percentage) avg_on_time
FROM seller_metrics
)

SELECT sm.*,
 CASE
	WHEN sm.avg_rating < b.avg_rating
	AND
    sm.on_time_percentage > b.avg_on_time
    THEN 'Investigate Product / Service Quality'
    ELSE 'Normal'
    END AS recommendation
FROM seller_metrics sm
CROSS JOIN benchmark b
ORDER BY avg_rating ASC,
on_time_percentage DESC;


