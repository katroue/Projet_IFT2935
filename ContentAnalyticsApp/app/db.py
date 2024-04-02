import pyodbc
from flask import current_app, g

def get_db_connection():
    if 'db_connection' not in g:
        g.db_connection = pyodbc.connect(current_app.config['DATABASE_CONNECTION_STR'])
    return g.db_connection

def close_db_connection(e=None):
    db_connection = g.pop('db_connection', None)

    if db_connection is not None:
        db_connection.close()

def init_app(app):
    app.teardown_appcontext(close_db_connection)
