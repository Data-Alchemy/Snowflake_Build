Create or replace database ADMIN    Comment = 'The ADMIN database contains tables to support administration of Snowflake account ';
Create schema SECOPS                Comment = 'SECOPS schema contains object supporting security operations in the account ';
Grant usage on database ADMIN to useradmin;
Grant usage on schema SECOPS to useradmin;

USE ADMIN.SECOPS;

CREATE TABLE rbac_grants (
	--
  id               VARCHAR(40)   DEFAULT UUID_STRING()          NOT NULL,
  future_grant     BOOLEAN                                      NOT NULL,
  privilege        VARCHAR(255)                                 NOT NULL,
  object_level     VARCHAR(255)                                 NOT NULL,
  role_level       VARCHAR(255)                                 NOT NULL,
  ordinal          INTEGER                                      NOT NULL,
  created_role     VARCHAR(255)  DEFAULT CURRENT_ROLE()         NOT NULL,
  created_by       VARCHAR(100)  DEFAULT CURRENT_USER()         NOT NULL,
  created_on       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP()    NOT NULL,
  updated_role     VARCHAR(255)  DEFAULT CURRENT_ROLE()         NOT NULL,
  updated_by       VARCHAR(100)  DEFAULT CURRENT_USER()         NOT NULL,
  updated_on       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP()    NOT NULL
--
) 
  COMMENT = 'Contains the grants required by RBAC access role best practices' ;

Alter table rbac_grants add constraint pk_rbac_grants Primary Key (id)

UPDATE  "ADMIN".SECOPS.rbac_grants
set PARENT_HIERARCHY = 'ADMIN'
where role_level = 'ROOT'

INSERT INTO "ADMIN".SECOPS.rbac_grants (privilege,  object_level, role_level, future_grant, ordinal)
VALUES 
      ('SELECT ON ALL TABLES IN',                                   'SCHEMA', 'RX',             TRUE,  01)
     ,('SELECT ON ALL VIEWS IN',                                    'SCHEMA', 'RX',             TRUE,  02)
     ,('USAGE, READ ON ALL STAGES IN ',                             'SCHEMA', 'RX',             TRUE,  03)
     ,('USAGE ON ALL FILE FORMATS IN ',                             'SCHEMA', 'RX',             TRUE,  04)
     ,('SELECT ON ALL STREAMS IN',                                  'SCHEMA', 'RX',             TRUE,  05)
     ,('USAGE ON ALL FUNCTIONS IN ',                                'SCHEMA', 'RX',             TRUE,  06)
     ,('INSERT, UPDATE, DELETE, REFERENCES ON ALL TABLES IN',       'SCHEMA', 'RWX',            TRUE,  07)
     ,('READ, WRITE ON ALL STAGES IN',                              'SCHEMA', 'RWX',            TRUE,  08)
     ,('USAGE ON ALL SEQUENCES IN',                                 'SCHEMA', 'RWX',            TRUE,  09)
     ,('USAGE ON ALL PROCEDURES IN',                                'SCHEMA', 'RWX',            TRUE,  10)
     ,('MONITOR, OPERATE ON ALL TASKS IN',                          'SCHEMA', 'RWX',            TRUE,  11)
     ,('OWNERSHIP ON ALL TABLES IN',                                'SCHEMA', 'ROOT',           TRUE,  12)
     ,('OWNERSHIP ON ALL EXTERNAL TABLES IN',                       'SCHEMA', 'ROOT',           TRUE,  13)
     ,('OWNERSHIP ON ALL VIEWS IN',                                 'SCHEMA', 'ROOT',           TRUE,  14)
     ,('OWNERSHIP ON ALL MATERIALIZED VIEWS IN',                    'SCHEMA', 'ROOT',           TRUE,  15)
     ,('OWNERSHIP ON ALL STAGES IN',                                'SCHEMA', 'ROOT',           TRUE,  16)
     ,('OWNERSHIP ON ALL FILE FORMATS IN',                          'SCHEMA', 'ROOT',           TRUE,  17)
     ,('OWNERSHIP ON ALL STREAMS IN',                               'SCHEMA', 'ROOT',           TRUE,  18)
     ,('OWNERSHIP ON ALL PROCEDURES IN',                            'SCHEMA', 'ROOT',           TRUE,  19)
     ,('OWNERSHIP ON ALL FUNCTIONS IN',                             'SCHEMA', 'ROOT',           TRUE,  20)
     ,('OWNERSHIP ON ALL SEQUENCES IN',                             'SCHEMA', 'ROOT',           TRUE,  21)
     ,('OWNERSHIP ON ALL TASKS IN',                                 'SCHEMA', 'ROOT',           TRUE,  22)
     ,('CREATE TABLE ON',                                           'SCHEMA', 'ROOT',           FALSE, 23)
     ,('CREATE VIEW ON ',                                           'SCHEMA', 'ROOT',           FALSE, 24)
     ,('CREATE FILE FORMAT ON',                                     'SCHEMA', 'ROOT',           FALSE, 25)
     ,('CREATE SEQUENCE ON ',                                       'SCHEMA', 'ROOT',           FALSE, 26)
     ,('CREATE FUNCTION ON ',                                       'SCHEMA', 'ROOT',           FALSE, 27)
     ,('CREATE STREAM ON',                                          'SCHEMA', 'ROOT',           FALSE, 28)
     ,('CREATE TASK ON ',                                           'SCHEMA', 'ROOT',           FALSE, 29)
     ,('CREATE PROCEDURE ON ',                                      'SCHEMA', 'ROOT',           FALSE, 30)
     ,('CREATE EXTERNAL TABLE ON ',                                 'SCHEMA', 'ROOT',           FALSE, 31)
     ,('CREATE STAGE ON',                                           'SCHEMA', 'ROOT',           FALSE, 32)
     ,('CREATE PIPE ON ',                                           'SCHEMA', 'ROOT',           FALSE, 33)
     ,('SELECT ON FUTURE TABLES IN',                                'SCHEMA', 'RX',             TRUE,  34)
     ,('SELECT ON FUTURE VIEWS IN',                                 'SCHEMA', 'RX',             TRUE,  35)
     ,('USAGE, READ ON FUTURE STAGES IN',                           'SCHEMA', 'RX',             TRUE,  36)
     ,('USAGE ON FUTURE FILE FORMATS IN',                           'SCHEMA', 'RX',             TRUE,  37)
     ,('SELECT ON FUTURE STREAMS IN',                               'SCHEMA', 'RX',             TRUE,  38)
     ,('USAGE ON FUTURE FUNCTIONS IN',                              'SCHEMA', 'RX',             TRUE,  39)
     ,('INSERT, UPDATE, DELETE, REFERENCES ON FUTURE TABLES IN',    'SCHEMA', 'RWX',            TRUE,  40)
     ,('READ, WRITE ON FUTURE STAGES IN',                           'SCHEMA', 'RWX',            TRUE,  41)
     ,('USAGE ON FUTURE SEQUENCES IN',                              'SCHEMA', 'RWX',            TRUE,  42)
     ,('USAGE ON FUTURE PROCEDURES IN',                             'SCHEMA', 'RWX',            TRUE,  43)
     ,('MONITOR, OPERATE ON FUTURE TASKS IN',                       'SCHEMA', 'RWX',            TRUE,  44)
     ,('OWNERSHIP ON FUTURE TABLES IN',                             'SCHEMA', 'ROOT',           TRUE,  45)
     ,('OWNERSHIP ON FUTURE EXTERNAL TABLES IN',                    'SCHEMA', 'ROOT',           TRUE,  46)
     ,('OWNERSHIP ON FUTURE VIEWS IN',                              'SCHEMA', 'ROOT',           TRUE,  47)
     ,('OWNERSHIP ON FUTURE MATERIALIZED VIEWS IN',                 'SCHEMA', 'ROOT',           TRUE,  48)
     ,('OWNERSHIP ON FUTURE STAGES IN',                             'SCHEMA', 'ROOT',           TRUE,  49)
     ,('OWNERSHIP ON FUTURE FILE FORMATS IN',                       'SCHEMA', 'ROOT',           TRUE,  50)
     ,('OWNERSHIP ON FUTURE STREAMS IN',                            'SCHEMA', 'ROOT',           TRUE,  51)
     ,('OWNERSHIP ON FUTURE PROCEDURES IN',                         'SCHEMA', 'ROOT',           TRUE,  52)
     ,('OWNERSHIP ON FUTURE FUNCTIONS IN',                          'SCHEMA', 'ROOT',           TRUE,  53)
     ,('OWNERSHIP ON FUTURE SEQUENCES IN',                          'SCHEMA', 'ROOT',           TRUE,  54)
     ,('OWNERSHIP ON FUTURE TASKS IN',                              'SCHEMA', 'ROOT',           TRUE,  55)


    
     USE ADMIN.SECOPS; 
     Select * from rbac_grants
