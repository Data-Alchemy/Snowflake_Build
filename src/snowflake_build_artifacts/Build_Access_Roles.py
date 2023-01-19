import pandas as pd
import snowflake.connector
import getpass as pwd
import time

# Gets the version

pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth',None)

default_warehouse = 'PROD_ANALYTICS_WH'


ctx = snowflake.connector.connect(
    user    = '',
    password= '',
    account=''
    )

gen_schema_sql = '''
USE ROLE PROD_ADMIN;
USE PROD_BRONZE_DB;
USE WAREHOUSE PROD_DATA_ENG_WH;
show schemas in account;
'''

cursor_list=  ctx.execute_string(f'{gen_schema_sql}',remove_comments=True)
schema_df = pd.DataFrame(cursor_list[-1],columns=['timestamp','Schema','n','n2','Database','Owner','Comment','n3','active'])
schema_df = schema_df[['Database','Schema']]
schema_df_filter = schema_df['Schema'].str.contains('INFORMATION_SCHEMA')==False
schema_df = schema_df[schema_df_filter]
#print(schema_df)

gen_permissions_sql = '''
USE ROLE SYSADMIN;
USE DATABASE ADMIN;
USE SCHEMA SECOPS;
SELECT * FROM RBAC_GRANTS
'''
cursor_list         =  ctx.execute_string(f'{gen_permissions_sql}',remove_comments=True)
permissions_df      = pd.DataFrame(cursor_list[-1],columns=['id','future_grant','privilege','object_level','role_level','ordinal','created_role','created_by','created_on','updated_role','updated_by','updated_on','PARENT_HIERARCHY'])
permissions_df      = permissions_df[['future_grant','privilege','role_level','PARENT_HIERARCHY']]



permission_schema_df                                = schema_df.merge(permissions_df, how = 'cross')
permission_schema_df['Role_Name']                   = permission_schema_df.apply(lambda x: f'{x["Database"]}_{x["Schema"]}_{x["role_level"]}',axis = 1 )
permission_schema_df['Parent_Role_Name']            = permission_schema_df.apply(lambda x: f'{x["Database"]}_{x["Schema"]}_{x["PARENT_HIERARCHY"]}',axis = 1 )
permission_schema_df['Role_Groups']                 = permission_schema_df.apply(lambda x: f'{x["Database"]}_{x["role_level"]}',axis = 1 )
permission_schema_df['Parent_Role_Groups']          = permission_schema_df.apply(lambda x: f'{x["Database"]}_{x["PARENT_HIERARCHY"]}' if x['PARENT_HIERARCHY']!= "ADMIN" else ('PROD_ADMIN'),axis = 1 )
permission_schema_df['Create Permission Roles']     = permission_schema_df.apply(lambda x: f'Create or Replace role {x["Role_Name"]};',axis = 1 )
permission_schema_df['Create Permission Groups']    = permission_schema_df.apply(lambda x: f'Create or Replace role {x["Role_Groups"]};',axis = 1 )
permission_schema_df['Grant Roles to Groups']       = permission_schema_df.apply(lambda x: f'Grant role {x["Role_Name"]} to role {x["Role_Groups"]};',axis = 1 )
permission_schema_df['Cascade Role Grants']         = permission_schema_df.apply(lambda x: f'Grant role {x["Role_Name"]} to role {x["Parent_Role_Name"]};'if x['PARENT_HIERARCHY']!= "ADMIN" else (f'Grant role {x["Role_Name"]} to role PROD_ADMIN;'),axis = 1 )
permission_schema_df['Cascade Group Grants']        = permission_schema_df.apply(lambda x: f'Grant role {x["Role_Groups"]} to role {x["Parent_Role_Groups"]};'if x['PARENT_HIERARCHY']!= "ADMIN" else (f'Grant role {x["Role_Groups"]} to role PROD_ADMIN;'),axis = 1 )
permission_schema_df['Grant Warehouse Usage']       = permission_schema_df.apply(lambda x: f'Grant Usage on WAREHOUSE {default_warehouse} to role {x["Role_Name"]};', axis = 1 )
permission_schema_df['Grant Database Usage']        = permission_schema_df.apply(lambda x: f'Grant Usage on Database {x["Database"]} to role {x["Role_Name"]};', axis = 1 )
permission_schema_df['Grant Usage']                 = permission_schema_df.apply(lambda x: f'Grant Usage on SCHEMA {x["Database"]}.{x["Schema"]} to role {x["Role_Name"]};', axis = 1 )
permission_schema_df['Issue Grants']                = permission_schema_df.apply(lambda x : f'Grant {x["privilege"]} SCHEMA {x["Database"]}.{x["Schema"]} to role {x["Role_Name"]} COPY CURRENT GRANTS;' if "OWNERSHIP" in x["privilege"] else f'Grant {x["privilege"]} SCHEMA {x["Database"]}.{x["Schema"]} to role {x["Role_Name"]};', axis =1 )

### generate sql executabel ###
listofdf = []
# create sql elements #
sql_create_roles                    = permission_schema_df['Create Permission Roles'].drop_duplicates()
sql_create_groups                   = permission_schema_df['Create Permission Groups'].drop_duplicates()
sql_grant_roles_to_group            = permission_schema_df['Grant Roles to Groups'].drop_duplicates()
sql_cascade_roles                   = permission_schema_df['Cascade Role Grants'].drop_duplicates()
sql_cascade_groups                  = permission_schema_df['Cascade Group Grants'].drop_duplicates()
sql_grant_warehouse_usage           = permission_schema_df['Grant Warehouse Usage'].drop_duplicates()
sql_grant_database_usage            = permission_schema_df['Grant Database Usage'].drop_duplicates()
sql_grant_usage                     = permission_schema_df['Grant Usage'].drop_duplicates()
sql_issue_grants                    = permission_schema_df['Issue Grants'].drop_duplicates()

# combine sql elements into a single sql list #
listofdf.append(sql_create_roles)
listofdf.append(sql_create_groups)
listofdf.append(sql_grant_roles_to_group)
listofdf.append(sql_cascade_roles)
listofdf.append(sql_cascade_groups)
listofdf.append(sql_grant_warehouse_usage)
listofdf.append(sql_grant_database_usage)
listofdf.append(sql_grant_usage)
listofdf.append(sql_issue_grants)
build_all_permissions   = pd.concat(listofdf)


build_all_permissions= build_all_permissions.to_string(index=False)
print(build_all_permissions) #sysout before execute
time.sleep(5)

# build and execute #
#exe_permission_matrix=  ctx.execute_string(f'USE ROLE ACCOUNTADMIN;{build_all_permissions}',remove_comments=True)
#for c in exe_permission_matrix:
#    for row in c :
#        print(row)
