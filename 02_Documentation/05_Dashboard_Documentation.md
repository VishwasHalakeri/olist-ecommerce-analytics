# Power BI Dashboard Documentation

---

## Overview

The Power BI solution was developed to transform transactional e-commerce data into interactive business dashboards.

The dashboards are built using SQL reporting views created in MySQL, allowing business users to analyze sales performance, customer behavior, logistics efficiency, seller performance, and executive KPIs through an intuitive reporting interface.

The report consists of one landing page, five analytical dashboards, and four detailed drill-through reports.

---

## Dashboard Navigation

The Power BI report contains the following pages:

- Home Page
- Executive Dashboard
- Sales Dashboard
- Customer Dashboard
- Operations Dashboard
- Seller Dashboard
- Sales Detailed Report
- Customer Detailed Report
- Operations Detailed Report
- Seller Detailed Report

Navigation buttons are available on the Home Page to access each analytical dashboard.

---

## Dashboard Summary

| Dashboard | Purpose |
|------------|---------|
| Home | Landing page and dashboard navigation |
| Executive Dashboard | Overall business performance |
| Sales Dashboard | Revenue and sales analysis |
| Customer Dashboard | Customer behavior analysis |
| Operations Dashboard | Logistics and delivery analysis |
| Seller Dashboard | Seller performance analysis |

---

# Home Page

# Project Overview 

![Project Overview](06_Images/01_Project Overview.png)

## Business Objective
...

## Purpose

The Home Page acts as the landing page for the Power BI report.

It provides navigation to all analytical dashboards and gives users a quick understanding of the project before exploring the reports.

---

### Features

- Project Title
- Project Description
- Dashboard Navigation Buttons
- Professional Branding

---

### Business Value

Provides a clean and user-friendly entry point for business users.

---

# Executive Dashboard

![Executive Dashboard](06_Images/02_Executive_Dashboard.png)

## Business Objective

Provide executives with a high-level overview of marketplace performance.

---

### KPIs

- Total Revenue
- Total Orders
- Total Customers
- Average Order Value
- Average Rating
- On-Time Delivery %

---

### Visuals

- Monthly Revenue Trend
- Monthly Orders Trend
- Top Product Categories
- Top Seller States

---

### Slicers

- Year
- Month

---

### Business Questions Answered

- How is the marketplace performing?
- Is revenue increasing over time?
- Which product categories generate the most revenue?
- Which seller regions contribute the highest sales?

---

### Business Insights

Executives can monitor marketplace growth, customer activity, and overall business health from a single dashboard.

---

# Sales Dashboard

![Sales Dashboard](06_Images/03_Sales_Dashboard.png)

## Business Objective

Analyze marketplace sales performance over time.

---

### KPIs

- Total Revenue
- Completed Orders
- Average Order Value
- Revenue per Customer
- Freight Revenue
- Freight per Order

---

### Visuals

- Revenue Trend
- Orders Trend
- Revenue by Month
- Revenue by Product Category
- Revenue by State
- Top Products

---

### Slicers

- Year
- Month
- State

---

### Business Questions Answered

- How has revenue changed over time?
- Which states generate the highest revenue?
- Which product categories perform best?
- Which products contribute the most sales?

---

### Business Insights

The dashboard highlights revenue trends, regional performance, and product sales to support sales planning and inventory management.

---

# Customer Dashboard

![Customer Dashboard](06_Images/05_Customer_Dashboard.png)

## Business Objective

Understand customer purchasing behavior and regional customer distribution.

---

### KPIs

- Total Customers
- Total Revenue
- Average Revenue per Customer
- Average Order Value
- Average Review Rating
- On-Time Delivery %

---

### Visuals

- Customer Growth Trend
- Revenue by State
- Customers by State
- Customer Segmentation
- Review Rating Distribution
- Top Customer States

---

### Slicers

- Year
- Month
- Customer State

---

### Business Questions Answered

- Where are customers located?
- Which regions generate the highest revenue?
- How satisfied are customers?
- How does delivery affect customer experience?

---

### Business Insights

The dashboard helps understand customer demographics, purchasing patterns, and customer satisfaction.

---

# Operations Dashboard

![Operations Dashboard](06_Images/07_Operations_Dashboard.png)

## Business Objective

Evaluate logistics performance and delivery efficiency.

---

### KPIs

- Delivered Orders
- On-Time Delivery %
- Delayed Orders
- Average Delivery Days
- Average Delay Days
- Freight Revenue

---

### Visuals

- Delivery Trend
- Delay Trend
- Freight Revenue Trend
- Delivery Performance
- Delay Analysis
- Logistics KPIs by Month

---

### Slicers

- Year
- Month

---

### Business Questions Answered

- Are deliveries improving?
- How many deliveries are delayed?
- What is the average delivery time?
- How much revenue is spent on freight?

---

### Business Insights

The dashboard helps monitor delivery performance and identify logistics bottlenecks.

---

# Seller Dashboard

![Seller Dashboard](06_Images/09_Seller_Dashboard.png)


## Business Objective

Evaluate seller performance across revenue, customer satisfaction, and delivery performance.

---

### KPIs

- Active Sellers
- Total Revenue
- Average Revenue per Seller
- Average Seller Rating
- Average Delivery Days
- On-Time Delivery %

---

### Visuals

- Seller Revenue Trend
- Top Sellers
- Seller Rating Distribution
- Seller Performance Tier
- Seller State Analysis
- Revenue by Seller

---

### Slicers

- Year
- Month
- Seller State

---

### Business Questions Answered

- Which sellers generate the highest revenue?
- Which sellers maintain high customer ratings?
- Which seller regions perform best?
- Which sellers require improvement?

---

### Business Insights

The dashboard enables comparison of seller performance and supports data-driven seller management.

---

# Detailed Reports

# Sales Detailed Report

![Sales Report](06_Images/04_Sales_Report.png)

# Customer Detailed Report

![Customer Report](06_Images/06_Customer_Report.png)

# Operations Detailed Report

![Operations Report](06_Images/08_Operations_Report.png)

# Seller Detailed Report

![Seller Report](06_Images/10_Seller_Report.png)

Four detailed reports were created to allow users to drill into transactional information.

The detailed reports include:

- Sales Detailed Report
- Customer Detailed Report
- Operations Detailed Report
- Seller Detailed Report

These reports enable users to investigate the underlying records supporting dashboard KPIs and visualizations.

Each detailed report inherits filters applied from the main dashboard through drill-through functionality.

---

# Interactive Features

The Power BI solution includes several interactive features:

- Navigation Buttons
- Drill-through Reports
- Cross-filtering Between Visuals
- Dynamic Slicers
- Dynamic KPI Cards
- Month-over-Month KPI Indicators
- Tooltips

---

# Business Impact

The dashboards provide a centralized reporting solution that enables business users to monitor marketplace performance without writing SQL queries.

The solution supports decision-making across executive management, sales, customer analytics, logistics operations, and seller management by presenting key business metrics through interactive visualizations.

---

