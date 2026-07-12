# Python ETL & Exploratory Data Analysis Documentation

---

## Overview

Python was used to prepare the Olist E-Commerce dataset before loading it into MySQL for SQL analysis and Power BI reporting.

The workflow included data extraction, data cleaning, data transformation, exploratory data analysis (EDA), and exporting cleaned datasets.

This preprocessing ensured that the data used for reporting was accurate, consistent, and suitable for business analysis.

---

## Technology Stack

| Tool | Purpose |
|------|---------|
| Python | Data Processing |
| Pandas | Data Cleaning & Transformation |
| NumPy | Numerical Operations |
| Matplotlib | Data Visualization |
| Jupyter Notebook | Development Environment |

---

## ETL Workflow

The ETL process consisted of the following stages:

1. Extract raw CSV datasets.
2. Load datasets into Pandas DataFrames.
3. Assess data quality.
4. Clean missing values.
5. Remove duplicate records.
6. Correct data types.
7. Validate primary and foreign keys.
8. Export cleaned datasets.
9. Load cleaned datasets into MySQL.

---

## Datasets Used

| Dataset |
|---------|
| Customers |
| Orders |
| Order Items |
| Payments |
| Reviews |
| Products |
| Sellers |
| Geolocation |
| Product Category Translation |

---

## Data Cleaning

The following data quality checks were performed:

- Missing value analysis
- Duplicate record detection
- Data type validation
- Date format conversion
- Null value handling
- Category standardization
- Primary key validation
- Foreign key validation

---

## Data Transformation

Several transformations were applied before loading the data into MySQL:

- Converted date columns into datetime format.
- Renamed columns for consistency.
- Standardized text values.
- Filtered invalid records.
- Created derived columns for business analysis.
- Exported cleaned datasets as CSV files.

---

## Exploratory Data Analysis

EDA was performed to understand the structure and quality of the datasets before SQL analysis.

The analysis included:

- Distribution of orders
- Monthly sales trend
- Product category analysis
- Customer distribution
- Seller distribution
- Delivery performance
- Review score analysis
- Payment analysis

---

## Key Python Tasks

The following tasks were completed using Python:

- Imported multiple CSV datasets.
- Merged datasets for analysis.
- Checked missing values.
- Removed duplicate records.
- Converted data types.
- Generated summary statistics.
- Created exploratory visualizations.
- Exported cleaned datasets for MySQL.

---

## Challenges Encountered

Several data quality issues were identified during preprocessing:

- Missing values in product attributes.
- Missing review comments.
- Duplicate geolocation records.
- Missing delivery timestamps.
- Inconsistent date formats.
- Null product categories.

These issues were resolved through appropriate data cleaning and transformation techniques before loading the data into MySQL.

---

## Project Workflow

The overall analytics workflow followed these steps:

Raw CSV Files

↓

Python ETL

↓

Data Cleaning

↓

Exploratory Data Analysis

↓

Cleaned CSV Files

↓

MySQL Database

↓

SQL Business Analysis

↓

SQL Reporting Views

↓

Power BI Dashboards

---

## Business Value

The Python preprocessing stage ensured that the reporting layer was built on clean and reliable data.

By identifying and resolving data quality issues before SQL analysis, the project produced more accurate KPIs and business insights for decision-makers.

---

## Skills Demonstrated

- Python Programming
- Pandas
- NumPy
- Data Cleaning
- Data Transformation
- Exploratory Data Analysis
- Data Validation
- CSV Processing
- MySQL Integration

---

