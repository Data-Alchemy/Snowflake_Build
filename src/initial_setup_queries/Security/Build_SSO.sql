
-----------------------------------
CREATE SECURITY INTEGRATION AZURE_AAD_INTEGRATION
TYPE = SAML2
ENABLED = TRUE
SAML2_ISSUER = 'https://sts.windows.net/{aad_tenant}/' -- (This is entity ID in the Identifier Provider Metadata downloaded earlier and will be in a URL format and it is the value "Azure AD Identifier" on the Azure AD. Make sure you preserve the trailing slash symbol)
SAML2_SSO_URL = 'https://login.microsoftonline.com/{aad_tenant}/saml2' --(this is the Login URL. you copied earlier)
SAML2_PROVIDER = 'CUSTOM'
SAML2_X509_CERT = '{sso_cert}' -- (DO NOT ENTER THE BEGIN OR END CERTIFICATE TAGS)
SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = 'AzureADSSO'
SAML2_ENABLE_SP_INITIATED = TRUE;
show parameters like 'SAML_IDENTITY_PROVIDER' in account;
desc security integration AZURE_AAD_INTEGRATION;
alter security integration AZURE_AAD_INTEGRATION set saml2_snowflake_acs_url = 'https://{snowflake_account_locator}.snowflakecomputing.com/fed/login';
alter security integration AZURE_AAD_INTEGRATION set saml2_snowflake_issuer_url = 'https://{snowflake_account_locator}.snowflakecomputing.com';
-----------------------------------------------------------------