# SQL Views Documentation

---

## Overview

Instead of connecting Power BI directly to multiple transactional tables, SQL reporting views were created in MySQL.

These views perform all required joins, aggregations, KPI calculations, and business logic before loading the data into Power BI.

Using SQL views provides several advantages:

- Simplifies the Power BI data model
- Improves dashboard performance
- Keeps business logic centralized
- Reduces duplicate DAX calculations
- Makes the reporting layer easier to maintain

---

## Reporting Architecture

Raw Tables

Customers
Orders
Order Items
Products
Payments
Reviews
Sellers

        │
        │

SQL Reporting Views
(MySQL)

Executive View
Sales View
Customer View
Logistics View
Seller View

        │
        │

Power BI

Executive Dashboard
Sales Dashboard
Customer Dashboard
Operations Dashboard
Seller Dashboard

---

## SQL View Summary

| SQL View | Dashboard | Purpose |
|----------|-----------|---------|
| vw_executive_dashboard_kpi | Executive Dashboard | Overall marketplace KPIs |
| vw_sales_performance_kpi | Sales Dashboard | Sales performance analysis |
| vw_customer_analytics_kpi | Customer Dashboard | Customer behaviour analysis |
| vw_logistics_kpi | Operations Dashboard | Delivery and logistics KPIs |
| vw_seller_performance_kpi | Seller Dashboard | Seller performance analysis |

---

### 1. Executive Dashboard View

View Name

vw_executive_dashboard_kpi

Purpose

Provides a high-level summary of marketplace performance by combining revenue, customers, completed orders, seller activity, ratings, and delivery metrics into a single reporting dataset.

Power BI Dashboard

Executive Dashboard

#### Source Tables

- Customers
- Orders
- Order Items
- Reviews
- Sellers
- Products

#### KPIs Generated

- Total Revenue
- Completed Orders
- Unique Customers
- Average Order Value
- Average Customer Rating
- On-Time Delivery %

#### Business Value

This reporting view allows management to monitor overall marketplace performance from a single dashboard without querying multiple transactional tables.

---

### 2. Sales Dashboard View

View Name

vw_sales_performance_kpi

Purpose

Aggregates monthly sales information including revenue, completed orders, customers, average order value, freight revenue, and revenue per customer.

Power BI Dashboard

Sales Dashboard

#### Source Tables

Orders

Order Items

Customers

#### KPIs Generated

Total Revenue

Completed Orders

Unique Customers

Average Order Value

Total Freight Revenue

Revenue per Customer

#### Business Value

Used to monitor monthly sales performance, identify revenue trends, and evaluate customer purchasing behaviour.

---

### 3. Customer Dashboard View

View Name

vw_customer_analytics_kpi

Purpose

Provides customer-focused metrics including customer growth, revenue contribution, ratings, geographic distribution, and delivery experience.

Power BI Dashboard

Customer Dashboard

#### KPIs Generated

Total Customers

Revenue Per Customer

Average Order Value

Average Review Rating

Customer States

On-Time Delivery %

#### Business Value

Helps understand customer behaviour, purchasing patterns, satisfaction, and regional distribution.

---

### 4. Operations Dashboard View

View Name

vw_logistics_kpi

Purpose

Measures delivery performance, freight cost, delivery delays, and logistics efficiency across the marketplace.

Power BI Dashboard

Operations Dashboard

#### KPIs Generated

Delivered Orders

On-Time Delivery %

Delayed Orders

Average Delivery Days

Average Delay Days

Freight Revenue

#### Business Value

Allows operations teams to monitor delivery performance and identify logistics bottlenecks.

---

### 5. Seller Dashboard View

View Name

vw_seller_performance_kpi

Purpose

Measures seller revenue, orders, ratings, delivery performance, and overall seller efficiency.

Power BI Dashboard

Sellers Dashboard

#### KPIs Generated

Active Sellers

Seller Revenue

Seller Orders

Revenue Per Seller

Average Seller Rating

On-Time Delivery %

#### Business Value

Enables comparison of seller performance and helps identify top-performing and underperforming sellers.

---

## Why SQL Views Were Used

The reporting layer was created using SQL views instead of querying raw transactional tables directly in Power BI.

Benefits include:

- Centralized business logic
- Cleaner Power BI model
- Better query performance
- Reduced DAX complexity
- Reusable reporting datasets
- Easier dashboard maintenance

---

## Technologies Used

- MySQL
- SQL Views
- Aggregate Functions
- Common Table Expressions (CTEs)
- CASE Statements
- GROUP BY
- JOIN Operations
- Power BI

---

SQL Views Documentation

Overview

Reporting Architecture

SQL View Summary

Executive View

Sales View

Customer View

Operations View

Seller View

Why SQL Views

Technologies Used

---