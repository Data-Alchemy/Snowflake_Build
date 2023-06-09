REATE OR REPLACE USER PROD_DEVOPS_ADMIN
PASSWORD     = '' 
COMMENT      = 'Service User for Developer Admin Operations' 
DISPLAY_NAME = 'Production Developer Admin' 
DEFAULT_ROLE = "PROD_ADMIN"
MUST_CHANGE_PASSWORD = FALSE;
--GRANT ROLE "SYSADMIN" TO USER PROD_DEVOPS_ADMIN;

-----------------------------------------------
CREATE OR REPLACE USER DEV_DEVOPS_ADMIN
PASSWORD     = ''
COMMENT      = 'Service User for Developer Admin Operations' 
DISPLAY_NAME = 'Development Developer Admin' 
DEFAULT_ROLE = "DEV_ADMIN"
MUST_CHANGE_PASSWORD = FALSE;
-----------------------------------------------
-----------------------------------------------
CREATE OR REPLACE USER PROD_BI_CONSUMER
PASSWORD     = ''
COMMENT      = 'Service User for Developer Admin Operations' 
DISPLAY_NAME = 'Prod Business Intelligence Consumer' 
DEFAULT_ROLE = "PROD_ANALYTICS"
MUST_CHANGE_PASSWORD = FALSE;
------------------------------
CREATE OR REPLACE USER DEV_BI_CONSUMER
PASSWORD     = ''
COMMENT      = 'Dev service user for consuming data for data visualizations' 
DISPLAY_NAME = 'Dev Business Intelligence Consumer' 
DEFAULT_ROLE = "DEV_ANALYTICS"
MUST_CHANGE_PASSWORD = FALSE;
------------------------------

------- Grant Functional Roles -------
USE ROLE ACCOUNTADMIN;
GRANT ROLE PROD_ADMIN to USER PROD_DEVOPS_ADMIN;

USE ROLE ACCOUNTADMIN;
GRANT ROLE DEV_ADMIN to USER DEV_DEVOPS_ADMIN;

------- Create Functional Roles -------
USE ROLE SECURITYADMIN;
CREATE OR REPLACE ROLE PROD_ADMIN;
CREATE OR REPLACE ROLE PROD_SECOPS;
CREATE OR REPLACE ROLE PROD_AUTOMATION;
CREATE OR REPLACE ROLE PROD_ANALYTICS;
CREATE OR REPLACE ROLE PROD_CONTINGENT;

CREATE or REPLACE ROLE DEV_ADMIN;
CREATE OR REPLACE ROLE DEV_SECOPS;
CREATE or REPLACE ROLE DEV_AUTOMATION;
CREATE OR REPLACE ROLE DEV_ANALYTICS;
CREATE OR REPLACE ROLE DEV_CONTINGENT;


------- Grant Functional Roles -------

GRANT ROLE PROD_ADMIN      TO ROLE SYSADMIN;
GRANT ROLE PROD_SECOPS     TO ROLE PROD_ADMIN;
GRANT ROLE PROD_AUTOMATION TO ROLE PROD_ADMIN;
GRANT ROLE PROD_ANALYTICS  TO ROLE PROD_ADMIN;
GRANT ROLE PROD_CONTINGENT TO ROLE PROD_ADMIN;

GRANT ROLE DEV_ADMIN      TO ROLE SYSADMIN;
GRANT ROLE DEV_SECOPS     TO ROLE DEV_ADMIN;
GRANT ROLE DEV_AUTOMATION TO ROLE DEV_ADMIN;
GRANT ROLE DEV_ANALYTICS  TO ROLE DEV_ADMIN;
GRANT ROLE DEV_CONTINGENT TO ROLE DEV_ADMIN;

------- Grant Usage on Prod WH -------

GRANT USAGE ON WAREHOUSE PROD_ANALYTICS_WH to ROLE PROD_ADMIN;
GRANT USAGE ON WAREHOUSE PROD_DATASCIENCE_WH to ROLE PROD_ADMIN;
GRANT USAGE ON WAREHOUSE PROD_DATA_ENG_WH to ROLE PROD_ADMIN;
GRANT USAGE ON WAREHOUSE PROD_ANALYTICS_WH to ROLE PROD_ANALYTICS;

------- Grant Usage on Dev WH -------

GRANT USAGE ON WAREHOUSE DEV_ANALYTICS_WH to ROLE DEV_ADMIN;
GRANT USAGE ON WAREHOUSE DEV_DATASCIENCE_WH to ROLE DEV_ADMIN;
GRANT USAGE ON WAREHOUSE DEV_DATA_ENG_WH to ROLE DEV_ADMIN;
GRANT USAGE ON WAREHOUSE DEV_ANALYTICS_WH to ROLE DEV_ANALYTICS;


------- Grant Usage on Prod DBS -------

GRANT USAGE ON DATABASE PROD_BRONZE_DB to ROLE PROD_ADMIN;
GRANT USAGE ON DATABASE PROD_GOLD_DB to ROLE PROD_ADMIN;
GRANT USAGE ON DATABASE PROD_SILVER_DB to ROLE PROD_ADMIN;


------- Grant Usage on Dev DBS -------

GRANT USAGE ON DATABASE DEV_BRONZE_DB to ROLE DEV_ADMIN;
GRANT USAGE ON DATABASE DEV_GOLD_DB to ROLE DEV_ADMIN;
GRANT USAGE ON DATABASE DEV_SILVER_DB to ROLE DEV_ADMIN;


USE DATABASE PROD_BRONZE_DB;
USE ROLE ACCOUNTADMIN;
USE SCHEMA STAGING;
GRANT USAGE ON ALL FILE FORMATS in SCHEMA PROD_BRONZE_DB.STAGING to ROLE PROD_ADMIN;
GRANT USAGE ON FUTURE FILE FORMATS in SCHEMA PROD_BRONZE_DB.STAGING to ROLE PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.STAGING to ROLE PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.APPLICATION_DATA to ROLE PROD_ADMIN;
GRANT all privileges on database PROD_BRONZE_DB to ROLE PROD_ADMIN
GRANT USAGE,READ,WRITE ON ALL STAGES in SCHEMA PROD_BRONZE_DB.STAGING to ROLE ACCOUNTADMIN;
GRANT CREATE STAGE on SCHEMA PROD_BRONZE_DB.STAGING to ROLE PROD_ADMIN;
GRANT OWNERSHIP on STAGE bronze_sandbox_data to ROLE PROD_ADMIN revoke current grants;

-----
GRANT USAGE ON ALL FILE FORMATS in SCHEMA PROD_BRONZE_DB.APPLICATION_DATA to ROLE PROD_ADMIN;
GRANT USAGE ON FUTURE FILE FORMATS in SCHEMA PROD_BRONZE_DB.APPLICATION_DATA to ROLE PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.APPLICATION_DATA to ROLE PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.APPLICATION_DATA to ROLE PROD_ADMIN;
GRANT all privileges on database PROD_BRONZE_DB to ROLE PROD_ADMIN;
GRANT USAGE,READ,WRITE ON ALL STAGES in SCHEMA PROD_BRONZE_DB.APPLICATION_DATA to ROLE PROD_ADMIN;
GRANT CREATE STAGE on SCHEMA PROD_BRONZE_DB.APPLICATION_DATA to ROLE PROD_ADMIN;

-------------------
GRANT USAGE ON ALL FILE FORMATS in SCHEMA PROD_BRONZE_DB.RETAIL_DATA to ROLE PROD_ANALYTICS;
GRANT USAGE ON FUTURE FILE FORMATS in SCHEMA PROD_BRONZE_DB.RETAIL_DATA to ROLE PROD_ANALYTICS;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.RETAIL_DATA to ROLE PROD_ANALYTICS;
GRANT USAGE,READ,WRITE ON ALL STAGES in SCHEMA PROD_BRONZE_DB.RETAIL_DATA to ROLE PROD_ANALYTICS;
REVOKE GRANT CREATE STAGE on SCHEMA PROD_BRONZE_DB.RETAIL_DATA to ROLE PROD_ANALYTICS;

-----------------

GRANT USAGE ON SCHEMA DEV_BRONZE_DB.APPLICATION_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_BRONZE_DB.FINANCE_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_BRONZE_DB.LEGACY_DW to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_BRONZE_DB.MASTER_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_BRONZE_DB.PEOPLE_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_BRONZE_DB.RETAIL_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_BRONZE_DB.SANDBOX_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_BRONZE_DB.SUPPLY_CHAIN to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_GOLD_DB.APPLICATION_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_GOLD_DB.FINANCE_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_GOLD_DB.LDW to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_GOLD_DB.LEGACY_DW to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_GOLD_DB.MASTER_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_GOLD_DB.PEOPLE_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_GOLD_DB.RETAIL_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_GOLD_DB.SANDBOX_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_GOLD_DB.SUPPLY_CHAIN to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_SILVER_DB.APPLICATION_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_SILVER_DB.FINANCE_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_SILVER_DB.LEGACY_DW to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_SILVER_DB.MASTER_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_SILVER_DB.PEOPLE_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_SILVER_DB.RETAIL_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_SILVER_DB.SANDBOX_DATA to role DEV_ADMIN;
GRANT USAGE ON SCHEMA DEV_SILVER_DB.SUPPLY_CHAIN to role DEV_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.APPLICATION_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.FINANCE_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.LEGACY_DW to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.MASTER_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.PEOPLE_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.RETAIL_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.STAGING to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_BRONZE_DB.SUPPLY_CHAIN to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_GOLD_DB.APPLICATION_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_GOLD_DB.FINANCE_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_GOLD_DB.LEGACY_DW to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_GOLD_DB.MASTER_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_GOLD_DB.PEOPLE_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_GOLD_DB.RETAIL_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_GOLD_DB.SUPPLY_CHAIN to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_SILVER_DB.APPLICATION_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_SILVER_DB.FINANCE_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_SILVER_DB.LEGACY_DW to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_SILVER_DB.MASTER_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_SILVER_DB.PEOPLE_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_SILVER_DB.RETAIL_DATA to role PROD_ADMIN;
GRANT USAGE ON SCHEMA PROD_SILVER_DB.SUPPLY_CHAIN to role PROD_ADMIN;

GRANT ROLE SYSADMIN to USER SYS_USER
