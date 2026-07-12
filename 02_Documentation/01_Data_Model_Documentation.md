# Data Model Documentation

## Overview

The Olist E-Commerce Analytics project is built using a relational database in MySQL.

The data model is designed to organize transactional data into multiple related tables. This structure supports efficient querying, business reporting, and dashboard development in Power BI.

The database contains customer, order, product, seller, payment, review, and location information.

---

# Database Name

ecommerce_olist_analytics

---

# Database Design

The database follows a relational model where orders act as the central business entity.

Each order is connected to customers, products, sellers, payments, and customer reviews through primary and foreign key relationships.

This design minimizes data redundancy and improves query performance.

---

## Database Summary

| Category | Count |
|----------|------:|
| Total Tables | 8 |
| Fact Tables | 3 |
| Dimension Tables | 5 |
| SQL Views | 5 |
| Relationships | 8 |

---

# Project Workflow

Raw CSV Files

↓

Python Data Cleaning

↓

Python ETL

↓

Clean CSV Files

↓

MySQL Database

↓

SQL Reporting Views

↓

Power BI Dashboards

↓

Business Insights

---

# Database Tables

## Customers

Purpose

Stores customer information for every order placed on the marketplace.

Primary Key

customer_id

Important Columns

- customer_id
- customer_unique_id
- customer_city
- customer_state

Business Use

Used to analyze customer distribution, customer growth, geographic trends, and customer purchasing behavior.


## Orders

Purpose

Stores information about every order placed on the marketplace.

Primary Key

order_id

Foreign Key

customer_id

Important Columns

- order_purchase_timestamp
- order_status
- order_estimated_delivery_date
- order_delivered_customer_date

Business Use

Used to analyze sales performance, order volume, delivery performance, and order lifecycle.


## Order Items

Purpose

Stores product-level information for every order.

Primary Key

order_id + order_item_id

Foreign Keys

order_id

product_id

seller_id

Important Columns

- price
- freight_value

Business Use

Used to calculate revenue, freight cost, seller revenue, and product performance.


## Products

Purpose

Stores product information sold on the marketplace.

Primary Key

product_id

Important Columns

- product_category_name
- product_weight_g
- product_length_cm
- product_width_cm
- product_height_cm

Business Use

Used for product category analysis and product performance reporting.


## Sellers

Purpose

Stores seller information.

Primary Key

seller_id

Important Columns

- seller_city
- seller_state

Business Use

Used to evaluate seller performance, revenue contribution, and regional distribution.


## Reviews

Purpose

Stores customer feedback after order completion.

Primary Key

review_id

Foreign Key

order_id

Important Columns

- review_score
- review_comment_title
- review_comment_message

Business Use

Used to measure customer satisfaction and average review ratings.


## Payments

Purpose

Stores payment information for each order.

Primary Key

order_id + payment_sequential

Important Columns

- payment_type
- payment_value
- payment_installments

Business Use

Used to analyze payment methods, payment value, and installment trends.


## Geolocation

Purpose

Stores customer and seller geographic coordinates.

Important Columns

- geolocation_zip_code_prefix
- geolocation_city
- geolocation_state

Business Use

Supports regional and geographic analysis.


## Category Translation

Purpose

Maps Portuguese product category names to English category names.

Primary Key

product_category_name

Business Use

Improves dashboard readability by displaying English category names instead of Portuguese.

---

# Table Relationships

### Customers

Stores customer information.

Primary Key

• customer_id

Connected To

• Orders

Relationship

Customers (1) → (Many) Orders

Purpose

Each customer can place multiple orders.



### Orders

Stores every order placed in the marketplace.

Primary Key

• order_id

Foreign Keys

• customer_id

Connected To

• Customers
• Order Items
• Payments
• Reviews

Purpose

Acts as the central transactional table used throughout the analytics project.


### Order Items

Contains product-level information for every order.

Primary Key

• order_id
• order_item_id

Foreign Keys

• order_id
• product_id
• seller_id

Connected To

• Orders
• Products
• Sellers

Purpose

Links products and sellers with customer orders while storing product price and freight value.


### Products

Contains product information.

Primary Key

• product_id

Foreign Keys

• product_category_name

Connected To

• Order Items
• Category Translation

Purpose

Provides product attributes including category, dimensions, and weight.


### Sellers

Stores seller information.

Primary Key

• seller_id

Connected To

• Order Items

Purpose

Represents marketplace sellers responsible for fulfilling customer orders.


### Reviews

Stores customer review ratings and comments.

Primary Key

• review_id

Foreign Keys

• order_id

Connected To

• Orders

Purpose

Used for customer satisfaction analysis and seller performance evaluation.


### Payments

Contains payment information for each order.

Primary Key

• order_id
• payment_sequential

Foreign Keys

• order_id

Connected To

• Orders

Purpose

Stores payment type, installments, and payment value.


### Category Translation

Maps Portuguese product categories to English.

Primary Key

• product_category_name

Connected To

• Products

Purpose

Provides readable English product category names for reporting.


### Geolocation

Contains Brazilian geographic reference information.

Primary Key

No primary key.

Purpose

Used for geographical analysis when required.

This table was not directly used in the Power BI dashboards.

---

## Relationship Summary

| Parent Table | Child Table | Relationship |
|--------------|------------|--------------|
| Customers | Orders | One-to-Many |
| Orders | Order Items | One-to-Many |
| Orders | Payments | One-to-Many |
| Orders | Reviews | One-to-Many |
| Products | Order Items | One-to-Many |
| Sellers | Order Items | One-to-Many |
| Category Translation | Products | One-to-Many |

---

# Entity Relationship Diagram

The following ER Diagram illustrates the relationships between the tables used in this project.

![ER Diagram]("C:/Users/ASHOK/Desktop/Data Analyst/Project Documentation/Olist E-Commerce Analytics/Images/ER_Diagram.png")

---

### ER Diagram Explanation

The Orders table serves as the central fact table in the database. It connects customer information, purchased products, sellers, payments, and customer reviews.

Order Items acts as the bridge between Orders, Products, and Sellers, allowing product-level sales analysis. Product categories are translated into English using the Category Translation table for reporting purposes.

This relational structure supports sales, customer, operations, and seller analytics while maintaining normalized data storage.

---


---
