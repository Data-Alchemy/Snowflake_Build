
CREATE SECURITY INTEGRATION AZ_INTEGRATION
TYPE = SAML2
ENABLED = TRUE
SAML2_ISSUER = 'https://sts.windows.net/{tenant}'
SAML_SSO_URL = 'https:://login.microsoftonline.com/{tenant}/saml2'
SAML2_PROVIDER = 'CUSTOM'
SAML2_X509_CERT = '{cert}'
SAML2_SP_INITIATED_LOGIN_PAGE_LABLE='AzureADSSO'
SAML2_ENABLE_SP_INITIATED  = TRUE;

Alter SECURITY INTEGRATION AZ_INTEGRATION set saml2_snowflake_acs_url = '{snowflake_account_url}';
Alter SECURITY INTEGRATION AZ_INTEGRATION set saml2_snowflake_issuer_url = '{snowflake_account_url}';