
from dotenv import load_dotenv
import subprocess
import platform
import json
import sys
import os

from ast import Str
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
from snowflake.connector.pandas_tools import pd_writer
import pandas as pd
import os
import datetime
import re

###########################################################################
########################## Pandas Settings ################################
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth',None)
###########################################################################



class SnowPipe():

    def __init__(self,org,warehouse,usr,pwd,role,database,schema=None, cleanup=False):
        self.org            = org
        self.warehouse      = warehouse
        self.usr            = usr
        self.pwd            = pwd
        self.role           = role
        self.database       = database
        self.schema         = schema
        self.cleanup        = cleanup

    @property
    def Validate_Parms(self):
         return {'org'              : self.org,
                 'usr'              : self.usr,
                 'warehouse'        : self.warehouse,
                 'pwd'              : self.pwd,
                 'role'             : self.role,
                 'database'         : self.database,
                 'schema'           : self.schema,
                 }
    @property
    def Connection_Cursor(self) -> snowflake.connector.connect:
        try:
            ctx = snowflake.connector.connect(
                user        =self.usr,
                password    =self.pwd,
                account     =self.org
            )
            return ctx
        except Exception as e:
            print(f"connection to Snowflake failed \n Error received {e}:")

class Snowpark():

    '''
    This class enables communication with Snowflake using the Snowpark connector. Credentials need to be added to Snowflake.json in format seen below

    {
    "account"   : ""   ,
    "user"      : ""   ,
    "password"  : ""   ,
    "database"  : ""   ,
    "warehouse" : ""   ,
    "schema"    : ""   ,
    "role"      : ""
    }
    '''

    def __init__(self,connection_parameters):
        self.conntection_parameters = connection_parameters

    @property
    def snowpark_session(self):
        self.session = Session.builder.configs(self.conntection_parameters).create()
        return self.session

    @property
    def validate_conn(self):
        self.current_db = self.snowpark_session.get_current_database()
        return self.current_db

    def execute_query(self,query):
        self.query = query
        self.query_results = self.snowpark_session.sql(f"""{self.query}""")
        return self.query_results

    def get_pdf(self,pdf_query)->pd.DataFrame:
        self.pdf_query = pdf_query
        self.pdf_results = pd.DataFrame(self.execute_query(self.pdf_query).collect())
        return self.pdf_results

    @property
    def end_session(self):
        self.snowpark_session.close()

