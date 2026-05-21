# End-to-End SQL Data Warehouse & ETL Pipeline

## 📌 Project Overview
This project demonstrates the end-to-end design, implementation, and optimization of an enterprise Data Warehouse utilizing a multi-layered architecture (**Bronze → Silver → Gold**). The pipeline integrates disparate raw data from transactional CRM and ERP operational systems, handles aggressive data cleansing and schema enforcement, and surfaces a fully modeled, business-ready **Star Schema** optimized for analytical workloads.

> 💡 **Attribution Note:** This project was built as an independent, hands-on implementation inspired by the data warehouse architecture patterns taught by Data With Bara. All code execution, pipeline optimization, and debugging of schema inconsistencies were performed independently.

---

## 🏗️ Data Warehouse Architecture

The architecture segregates data processing into three distinct logical schemas to ensure data integrity, traceability, and high performance:

1. **Bronze Layer (Raw Ingestion):** Acts as the landing zone for raw source data. Data from flat files (`.csv`) representing CRM data and ERP logs are loaded directly into staging tables without any alterations or transformations.
2. **Silver Layer (Cleansing & Standardization):** The engine room of the pipeline. Implemented via a master stored procedure, this layer executes:
   - Data deduplication using window functions (`ROW_NUMBER()`).
   - String trimming, formatting, and carriage return/line feed (`CHAR(13)/CHAR(10)`) removal.
   - Normalization of categorical flags (e.g., mapping 'M', 'S', 'Male', 'Female' to uniform outputs).
   - Type casting, missing value handling (`ISNULL`, `NULLIF`), and date alignment.
3. **Gold Layer (Dimensional Modeling):** Surfaces the clean data using optimized Database Views. It structures the data into a clear **Star Schema** consisting of cleanly decoupled Dimension tables and a centralized Fact table using surrogate key mappings.

---

## 📁 Repository Structure

```text
├── datasets/                 # Raw CSV source data files (CRM & ERP source systems)
│   ├── crm_cust_info.csv
│   ├── crm_prd_info.csv
│   ├── crm_sales_details.csv
│   ├── erp_CUST_AZ12.csv
│   ├── erp_LOC_A101.csv
│   └── erp_PX_CAT_G1V2.csv
└── scripts/                  # SQL Development scripts
    ├── init_database.sql     # Database initialization and schema creation
    ├── bronze/               # Bulk loading and DDL for raw ingestion
    ├── silver/               # silver_load_proc.sql (Master ETL Stored Procedure)
    └── gold/                 # ddl_gold.sql (Dimensional views for the Star Schema)
