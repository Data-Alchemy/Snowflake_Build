
----------------------------------------------------------------------------------------
                      --------- CREATE DB & Schemas  ---------             
  USE ROLE SYSADMIN;
  -- create dev databases for each data source: source1, source2 etc.,
  CREATE DATABASE bronze_db COMMENT = 'Bronze database is organized by source system';
 ----------------------------------------------------------------------------------------
 CREATE DATABASE silver_db COMMENT = 'Silver database is organized by source system';
 ---------------------------------------------------------------------------------------- 
 CREATE DATABASE gold_db COMMENT = 'Gold database is organized by business case';
 ----------------------------------------------------------------------------------------
                       --------- CREATE PROD WH ENV ----------
CREATE OR REPLACE WAREHOUSE DATA_ENG_WH 
WITH WAREHOUSE_SIZE = 'XSMALL' 
    WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300
    STATEMENT_TIMEOUT_IN_SECONDS = 3600
    INITIALLY_SUSPENDED = TRUE
    AUTO_RESUME = TRUE 
    MIN_CLUSTER_COUNT = 1 
    MAX_CLUSTER_COUNT = 1 
    SCALING_POLICY = 'STANDARD' 
COMMENT = 'Ipaas application and data transformation';
----------------------------------------------------------------------------------------
CREATE OR REPLACE WAREHOUSE DATASCIENCE_WH
WITH WAREHOUSE_SIZE = 'XSMALL' 
    WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300
    STATEMENT_TIMEOUT_IN_SECONDS = 3600
    INITIALLY_SUSPENDED = TRUE
    AUTO_RESUME = TRUE 
    MIN_CLUSTER_COUNT = 1 
    MAX_CLUSTER_COUNT = 2 
    SCALING_POLICY = 'STANDARD' 
COMMENT = 'Compute heavy workloads';
----------------------------------------------------------------------------------------
CREATE OR REPLACE WAREHOUSE ANALYTICS_WH
WITH WAREHOUSE_SIZE = 'XSMALL' 
    WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 600
    STATEMENT_TIMEOUT_IN_SECONDS = 3600
    INITIALLY_SUSPENDED = TRUE
    AUTO_RESUME = TRUE 
    MIN_CLUSTER_COUNT = 1 
    MAX_CLUSTER_COUNT = 2
    SCALING_POLICY = 'STANDARD' 
COMMENT = 'data exploration';
----------------------------------------------------------------------------------------
