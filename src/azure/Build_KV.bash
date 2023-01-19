
###
:`
To generate code using Azure CLI to create an Azure Key Vault called "snowflake-dev-01" in the "uswest2" region, and give the "snowflake_admin" service principal access to the Key Vault, you can use the following commands:
# create a resource group
az group create --name "snowflake-dev-01-rg" --location "uswest2"
# create a key vault
az keyvault create --name "snowflake-dev-01" --resource-group "snowflake-dev-01-rg" --location "uswest2"
# get the service principal id of snowflake_admin
snowflake_admin_sp_id=$(az ad sp show --id "snowflake_admin" --query "appId" -o tsv)
# give the snowflake_admin service principal access to the key vault
az keyvault set-policy --name "snowflake-dev-01" --spn $snowflake_admin_sp_id --secret-permissions get list
The first command creates a new resource group called "snowflake-dev-01-rg" in the "uswest2" region. The second command creates a new Key Vault called "snowflake-dev-01" in the resource group. The third command gets the service principal ID of the "snowflake_admin" service principal. The last command grants the "snowflake_admin" service principal access to the Key Vault with get and list permissions.
`
##


# create a resource group
az group create --name "snowflake-dev-01-rg" --location "uswest2"

# create a key vault
az keyvault create --name "snowflake-dev-01" --resource-group "snowflake-dev-01-rg" --location "uswest2"

# get the service principal id of snowflake_admin
snowflake_admin_sp_id=$(az ad sp show --id "snowflake_admin" --query "appId" -o tsv)





#######################################################################
#Non RBAC

# give the snowflake_admin service principal access to the key vault
az keyvault set-policy --name "snowflake-dev-01" --spn $snowflake_admin_sp_id --secret-permissions get list
#######################################################################


# RBAC
az ad sp create-for-rbac --name Snowflake_Key_Manger
az role assignment create --role "Key Vault Secrets User" --assignee $snowflake_admin_sp_id --scope $kv_resource_id

######################################################################

