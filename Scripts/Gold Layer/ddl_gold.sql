IF OBJECT_ID('gold.dim_customers', 'V' )IS NOT NULL
   DROP VIEW gold.dim_customers ;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
        ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,      
        ci.cst_id  AS customer_id,
        ci.cst_key AS customer_number,
        ci.cst_firstname AS first_name,
        ci.cst_lastname AS lastname,
        ci.cst_marital_status as marital_status,
        cl.cntry AS country,
        ca.bdate as birthday,
        CASE 
        WHEN cst_gndr != 'n/a' THEN cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
        END AS gender,
        ci.cst_create_date AS create_date
        
FROM
silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
ON ci.cst_key = ca.cid 
LEFT JOIN silver.erp_loc_a101 cl 
ON ci.cst_key = cl.cid


GO



IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products
GO
CREATE VIEW gold.dim_products AS
SELECT 
pi.prd_id AS product_id,
pi.prd_key AS product_number,
pi.prd_nm AS product_name,
pi.cat_id AS category_id,
pc.cat AS category,
pc.subcat AS subcategory,
pc.maintenance AS maintenance,
pi.prd_line AS product_line,
pi.prd_start_dt AS product_start_date
FROM silver.crm_prd_info pi
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pi.cat_id =pc.id
WHERE pi.prd_end_dt IS NULL


GO


IF OBJECT_ID( 'gold.fact_sales_details', 'V') IS NOT NULL 
   DROP VIEW gold.fact_sales_details
GO
CREATE VIEW gold.fact_sales_details AS
SELECT
    sd.sls_ord_num AS order_number,
    dp.product_number AS product_key,
    dc.customer_id AS customer_id,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS ship_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_total,
    sd.sls_quantity AS sales_quantity,
    sd.sls_price AS sales_price
 FROM silver.crm_sales_details sd
 LEFT JOIN gold.dim_customers dc
 ON sd.sls_cust_id = dc.customer_id
 LEFT JOIN gold.dim_products dp
 ON sd.sls_prd_key = dp.product_name






