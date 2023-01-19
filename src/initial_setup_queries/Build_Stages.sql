USE ROLE SYSADMIN;
USE DATABASE BRONZE_DB;
USE Schema STAGING ;
Create or Replace Schema STAGING;

CREATE OR REPLACE file format csv_format
type = 'csv'
field_delimiter =','
FIELD_OPTIONALLY_ENCLOSED_BY='"'
skip_header = 1 
empty_field_as_null = true
;

CREATE OR REPLACE file format json_format
type = 'JSON'
strip_outer_array = true
;

CREATE OR REPLACE file format parquet_format
type = 'Parquet'
;


Drop stage bronze_application_data;
create or replace stage bronze_application_data
  url='azure://{}.blob.core.windows.net/application-data'
  credentials=(azure_sas_token='{bronze_application_data_token}')
  file_format = csv_format;

Drop stage bronze_finance_data;
create or replace stage bronze_finance_data
  url='azure://{}.blob.core.windows.net/finance-data'
  credentials=(azure_sas_token='{bronze_finance_data_token}')
  file_format = csv_format;

Drop stage bronze_master_data;
create or replace stage bronze_master_data
  url='azure://{}.blob.core.windows.net/master-data'
  credentials=(azure_sas_token='{bronze_master_data_token}')
  file_format = csv_format;

Drop stage bronze_people_data;
create or replace stage bronze_people_data
  url='azure://{}.blob.core.windows.net/people-data'
  credentials=(azure_sas_token='{bronze_people_data_token}')
  file_format = csv_format;

Drop stage bronze_retail_data;
create or replace stage bronze_retail_data
  url='azure://{}.blob.core.windows.net/retail-data'
  credentials=(azure_sas_token='{bronze_retail_data_token}')
  file_format = csv_format;

Drop stage bronze_sandbox_data;
create or replace stage bronze_sandbox_data
  url='azure://{}.blob.core.windows.net/sandbox-data'
  credentials=(azure_sas_token='{bronze_sandbox_data}')
  file_format = csv_format;

Drop stage bronze_supply_chain;
create or replace stage bronze_supply_chain
  url='azure://{}.blob.core.windows.net/supply-chain'
  credentials=(azure_sas_token='{bronze_supply_chain_token}')
  file_format = csv_format;
  
  create or replace stage silver_people_data
  url='azure://{}.blob.core.windows.net/people-data'
  credentials=(azure_sas_token='{silver_people_data_token}')
  file_format = csv_format;


  create or replace stage silver_application_data
  url='azure://{}.blob.core.windows.net/application-data'
  credentials=(azure_sas_token='{silver_application_data_token}')
  file_format = parquet_format;

