USE ecommerce_olist_analytics;


## Executive Sales KPI View

CREATE OR REPLACE VIEW vw_executive_sales_kpi AS
WITH monthly_sales AS
(
SELECT
        YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        ROUND(
            SUM(oi.price),
            2
        ) AS total_revenue,
        ROUND(
            SUM(oi.freight_value),
            2
        ) AS total_freight_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)
)

SELECT
    report_year,
    report_month,
    report_year * 100 + report_month
        AS year_month_key,
    total_orders,
    unique_customers,
    total_revenue,
    ROUND(
        total_revenue / total_orders,
        2
    ) AS average_order_value,
    total_freight_revenue,
    ROUND(
        total_freight_revenue / total_orders,
        2
    ) AS average_freight_per_order
FROM monthly_sales
ORDER BY
report_year,
report_month;


SELECT * FROM vw_executive_sales_kpi;




## Customer KPI View


CREATE OR REPLACE VIEW vw_customer_kpi AS
WITH customer_orders AS
(
SELECT
		YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        c.customer_state,
        COUNT(DISTINCT c.customer_id) AS unique_customers,
        COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
c.customer_state
),


customer_revenue AS
(
SELECT
        YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        c.customer_state,
        ROUND(SUM(oi.price),2) AS total_revenue,
        ROUND(
            SUM(oi.price)
            /
            COUNT(DISTINCT o.order_id),
        2) AS average_order_value
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
c.customer_state
),


customer_reviews AS
(
SELECT
        YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        c.customer_state,
        ROUND(
            AVG(r.review_score),
        2) AS average_review_score
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN reviews r ON o.order_id=r.order_id
WHERE o.order_status='delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
c.customer_state
),


customer_delivery AS
(
SELECT
        YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        c.customer_state,
        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) AS on_time_orders,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        ROUND(
            COUNT(
                DISTINCT CASE
                    WHEN o.order_delivered_customer_date
                         <= o.order_estimated_delivery_date
                    THEN o.order_id
                END
            )
            *100.0
            /
            COUNT(DISTINCT o.order_id),
        2) AS on_time_delivery_percentage
FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
WHERE o.order_status='delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
c.customer_state
)

SELECT
    co.report_year,
    co.report_month,
    (co.report_year * 100 + co.report_month) AS year_month_key,
    co.customer_state,
    co.unique_customers,
    co.total_orders,
    cr.total_revenue,
    cr.average_order_value,
    rv.average_review_score,
    cd.on_time_orders,
    cd.delivered_orders,
    cd.on_time_delivery_percentage
FROM customer_orders co
LEFT JOIN customer_revenue cr ON co.report_year=cr.report_year
AND co.report_month=cr.report_month
AND co.customer_state=cr.customer_state
LEFT JOIN customer_reviews rv ON co.report_year=rv.report_year
AND co.report_month=rv.report_month
AND co.customer_state=rv.customer_state
LEFT JOIN customer_delivery cd ON co.report_year=cd.report_year
AND co.report_month=cd.report_month
AND co.customer_state=cd.customer_state
ORDER BY
report_year,
report_month,
total_revenue DESC;


SELECT * FROM vw_customer_kpi;



## Logistic KPI View


CREATE OR REPLACE VIEW vw_logistics_kpi AS
SELECT
		YEAR(o.order_purchase_timestamp) AS report_year,
		MONTH(o.order_purchase_timestamp) AS report_month,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(
				DISTINCT CASE
								WHEN o.order_delivered_customer_date
								<= o.order_estimated_delivery_date
								THEN o.order_id
							END
			) AS on_time_orders,
		COUNT(
				DISTINCT CASE
								WHEN o.order_delivered_customer_date
								> o.order_estimated_delivery_date
								THEN o.order_id
				END
			) AS delayed_orders,
			ROUND(
					AVG(
						DATEDIFF(
								o.order_delivered_customer_date,
								o.order_purchase_timestamp
								)
						),
						2
					) AS average_delivery_days,
			ROUND(
					AVG(
						CASE
							WHEN o.order_delivered_customer_date >
							o.order_estimated_delivery_date
							THEN DATEDIFF(
											o.order_delivered_customer_date,
											o.order_estimated_delivery_date
											)
							ELSE 0
						END
						),
						2
					) AS average_delay_days,
			ROUND(
					SUM(oi.freight_value),
					2
				) AS total_freight_revenue,
			ROUND(
					SUM(oi.freight_value)
					/ COUNT(DISTINCT o.order_id),
					2
					) AS freight_per_order,
			ROUND(
					COUNT(
							DISTINCT CASE
										WHEN o.order_delivered_customer_date
										<= o.order_estimated_delivery_date
										THEN o.order_id
								END
							)
							*100.0
							/
							COUNT(DISTINCT o.order_id),
							2
				) AS on_time_delivery_percentage,
			ROUND(
					COUNT(
							DISTINCT CASE
										WHEN o.order_delivered_customer_date
										> o.order_estimated_delivery_date
										THEN o.order_id
							END
						)
						*100.0
						/
						COUNT(DISTINCT o.order_id),
						2
					) AS delay_rate_percentage
FROM orders o
JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)
ORDER BY
report_year,
report_month;


SELECT * FROM vw_logistics_kpi;



## Seller Performance KPI View


CREATE OR REPLACE VIEW vw_seller_performance_kpi AS
WITH seller_orders AS
(
SELECT
        YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        s.seller_id,
        s.seller_state,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT oi.product_id) AS total_products
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
s.seller_id,
s.seller_state
),


seller_revenue AS
(
SELECT
        YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        s.seller_id,
        ROUND(SUM(oi.price),2) AS total_revenue,
        ROUND(
            SUM(oi.price)
            /
            COUNT(DISTINCT o.order_id),
        2) AS average_order_value,
        ROUND(
            SUM(oi.price)
            /
            COUNT(DISTINCT oi.product_id),
        2) AS revenue_per_product
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status='delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
s.seller_id
),


seller_reviews AS
(
SELECT
        YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        oi.seller_id,
        ROUND(
            AVG(r.review_score),
        2) AS average_review_score
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status='delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
oi.seller_id
),


seller_delivery AS
(
SELECT
		YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
		oi.seller_id,
        ROUND(
            AVG(
                DATEDIFF(
                    o.order_delivered_customer_date,
                    o.order_purchase_timestamp
                )
            ),
        2) AS average_delivery_days,
        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN o.order_id
            END
        ) AS on_time_orders,
        COUNT(DISTINCT o.order_id)
            AS delivered_orders,
        ROUND(
            COUNT(
                DISTINCT CASE
                    WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN o.order_id
                END
            )
            *100.0
            /
            COUNT(DISTINCT o.order_id),
        2) AS on_time_delivery_percentage
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status='delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
oi.seller_id
),


benchmark AS
(
SELECT
        so.report_year,
        so.report_month,
        AVG(so.total_orders) AS avg_orders,
        AVG(sr.total_revenue) AS avg_revenue,
        AVG(rv.average_review_score) AS avg_rating,
        AVG(sd.on_time_delivery_percentage)
            AS avg_on_time
FROM seller_orders so
LEFT JOIN seller_revenue sr ON so.report_year = sr.report_year
AND so.report_month = sr.report_month
AND so.seller_id = sr.seller_id
LEFT JOIN seller_reviews rv ON so.report_year = rv.report_year
AND so.report_month = rv.report_month
AND so.seller_id = rv.seller_id
LEFT JOIN seller_delivery sd ON so.report_year = sd.report_year
AND so.report_month = sd.report_month
AND so.seller_id = sd.seller_id
GROUP BY
so.report_year,
so.report_month
)


SELECT
    so.report_year,
    so.report_month,
    so.report_year * 100 + so.report_month
        AS year_month_key,
    so.seller_id,
    so.seller_state,
    so.total_orders,
    so.total_products,
    sr.total_revenue,
    sr.average_order_value,
    sr.revenue_per_product,
    rv.average_review_score,
    sd.average_delivery_days,
    sd.on_time_orders,
    sd.delivered_orders,
    sd.on_time_delivery_percentage,
    CASE
        WHEN
            sr.total_revenue >= b.avg_revenue
            AND rv.average_review_score >= b.avg_rating
            AND sd.on_time_delivery_percentage >= b.avg_on_time
        THEN 'Top Performer'
        WHEN
            sr.total_revenue >= b.avg_revenue
            AND
            (
                rv.average_review_score < b.avg_rating
                OR
                sd.on_time_delivery_percentage < b.avg_on_time
            )
        THEN 'Revenue Strong - Needs Quality Improvement'
        WHEN
            sr.total_revenue < b.avg_revenue
            AND
            rv.average_review_score >= b.avg_rating
        THEN 'High Customer Satisfaction - Growth Opportunity'
        ELSE 'Needs Improvement'
    END AS seller_performance_tier
FROM seller_orders so
LEFT JOIN seller_revenue sr ON so.report_year = sr.report_year
AND so.report_month = sr.report_month
AND so.seller_id = sr.seller_id
LEFT JOIN seller_reviews rv ON so.report_year = rv.report_year
AND so.report_month = rv.report_month
AND so.seller_id = rv.seller_id
LEFT JOIN seller_delivery sd ON so.report_year = sd.report_year
AND so.report_month = sd.report_month
AND so.seller_id = sd.seller_id
LEFT JOIN benchmark b ON so.report_year = b.report_year
AND so.report_month = b.report_month
ORDER BY
    so.report_year,
    so.report_month,
    sr.total_revenue DESC;
    
    
SELECT * FROM vw_seller_performance_kpi;




## Monthly Executive Scorecard View


CREATE OR REPLACE VIEW vw_monthly_executive_scorecard AS
WITH monthly_orders AS 
(
SELECT
        YEAR(order_purchase_timestamp) AS report_year,
        MONTH(order_purchase_timestamp) AS report_month,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
WHERE order_status = 'delivered'
GROUP BY
YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp)
),


monthly_revenue AS 
(
SELECT
		YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        ROUND(SUM(oi.price),2) AS total_revenue,
        ROUND(SUM(oi.price)/COUNT(DISTINCT o.order_id),2) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status='delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)
),


monthly_reviews AS 
(
SELECT
        YEAR(o.order_purchase_timestamp) AS report_year,
        MONTH(o.order_purchase_timestamp) AS report_month,
        ROUND(AVG(r.review_score),2) AS average_review_score
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status='delivered'
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)
),


monthly_delivery AS 
(
SELECT
        YEAR(order_purchase_timestamp) AS report_year,
        MONTH(order_purchase_timestamp) AS report_month,
        COUNT(DISTINCT CASE
            WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN order_id
        END) AS on_time_orders,
        COUNT(DISTINCT order_id) AS delivered_orders,
        ROUND(
            COUNT(DISTINCT CASE
                WHEN order_delivered_customer_date <= order_estimated_delivery_date
                THEN order_id
            END) * 100.0
            /
            COUNT(DISTINCT order_id),
        2) AS on_time_delivery_percentage
FROM orders
WHERE order_status='delivered'
GROUP BY
YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp)
),


top_category AS 
(
SELECT *
FROM (
        SELECT
            YEAR(o.order_purchase_timestamp) AS report_year,
            MONTH(o.order_purchase_timestamp) AS report_month,
            COALESCE(ct.product_category_name_english,'Unknown')
            AS top_product_category,
            SUM(oi.price) AS revenue,
            ROW_NUMBER() OVER(
                PARTITION BY
                    YEAR(o.order_purchase_timestamp),
                    MONTH(o.order_purchase_timestamp)
                ORDER BY SUM(oi.price) DESC
            ) rn
        FROM orders o
        JOIN order_items oi ON o.order_id=oi.order_id
        JOIN products p ON oi.product_id=p.product_id
        LEFT JOIN category_translation ct ON p.product_category_name=ct.product_category_name
        WHERE o.order_status='delivered'
        GROUP BY
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            COALESCE(ct.product_category_name_english,'Unknown')
    ) t
    WHERE rn=1
),


top_seller AS 
(
SELECT *
FROM (
        SELECT
            YEAR(o.order_purchase_timestamp) AS report_year,
            MONTH(o.order_purchase_timestamp) AS report_month,
            oi.seller_id,
            SUM(oi.price) revenue,
            ROW_NUMBER() OVER(
                PARTITION BY
                    YEAR(o.order_purchase_timestamp),
                    MONTH(o.order_purchase_timestamp)
                ORDER BY SUM(oi.price) DESC
            ) rn
        FROM orders o
        JOIN order_items oi ON o.order_id=oi.order_id
        WHERE o.order_status='delivered'
        GROUP BY
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            oi.seller_id
    ) s
    WHERE rn=1
)


SELECT
    mo.report_year,
    mo.report_month,
    mo.report_year * 100 + mo.report_month
        AS year_month_key,
    mo.total_orders,
    mo.unique_customers,
    mr.total_revenue,
    mr.average_order_value,
    rv.average_review_score,
    md.on_time_orders,
    md.delivered_orders,
    md.on_time_delivery_percentage,
    tc.top_product_category,
    ts.seller_id AS top_seller
FROM monthly_orders mo
LEFT JOIN monthly_revenue mr ON mo.report_year=mr.report_year
AND mo.report_month=mr.report_month
LEFT JOIN monthly_reviews rv ON mo.report_year=rv.report_year
AND mo.report_month=rv.report_month
LEFT JOIN monthly_delivery md ON mo.report_year=md.report_year
AND mo.report_month=md.report_month
LEFT JOIN top_category tc ON mo.report_year=tc.report_year
AND mo.report_month=tc.report_month
LEFT JOIN top_seller ts ON mo.report_year=ts.report_year
AND mo.report_month=ts.report_month
ORDER BY
mo.report_year,
mo.report_month;


SELECT * FROM vw_monthly_executive_scorecard;




