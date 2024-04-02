import os

password = os.getenv('DB_PASSWORD')

class Config(object):
    DATABASE_CONNECTION_STR = (
        "Driver={ODBC Driver 17 for SQL Server};"
        "Server=localhost;"
        "Database=projet_base;"
        "Encrypt=yes;"
        "TrustServerCertificate=yes;"
        "UID=SA;"
        f"PWD={password}"
    )
