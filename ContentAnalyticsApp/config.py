import os

password = os.getenv('DB_PASSWORD')


class Config(object):
    DATABASE_CONNECTION_STR = (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost;"
        "DATABASE=projet_base;"
        "UID=SA;"
        "PWD=Password123;"
        "Encrypt=yes;"
        "TrustServerCertificate=yes;"
    )
