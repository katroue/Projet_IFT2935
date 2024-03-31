from flask import Flask, render_template
import pyodbc
import os

# conn_str = (
#     "Driver=ODBC Driver 17 for SQL Server;" #version du driver odbc
#     "Server=localhost;"                     #nom de l'instance 
#     "Database=projet_base;"                    #nom de la BD 
# 	"Encrypt=yes;"                         #chiffrer la connexion
#     "TrustServerCertificate=yes;"          #remplacer par "no" quand vous installez un certificat valide sur le serveur SQL
#     "UID=SA;"
#     "PWD=14011Ada"
# )


def connect_to_db(driver, server, database, uid, passwd):
    conn_str = (
        f"Driver={driver};"                     #version du driver odbc
        f"Server={server};"                     #nom de l'instance 
        f"Database={database};"                    #nom de la BD 
        "Encrypt=yes;"                         #chiffrer la connexion
        "TrustServerCertificate=yes;"          #remplacer par "no" quand vous installez un certificat valide sur le serveur SQL
        f"UID={uid};"
        f"PWD=14011Ada"
    )
    try:
        cnxn = pyodbc.connect(conn_str)
        print("Connection successful.")
        return cnxn
    except pyodbc.Error as e:
        print(f"An error occurred: {e}")
        # Depending on the use case, you might want to re-raise the exception
        # or return None to indicate the connection was not successful
        return None

app = Flask(__name__)

@app.route('/dashboard')
def dashboard():
    # Connection string variables
    driver = "ODBC Driver 17 for SQL Server"
    server = "localhost"
    database = "projet_base"
    uid = "SA"
    passwd = os.getenv('DB_PASSWORD')

    # Connect to database
    conn = connect_to_db(driver, server, database, uid, passwd)
    cursor = conn.cursor()

    # Assuming you have a stored procedure named 'GetDashboardData'
    cursor.execute("EXEC ViewCount")
    data = cursor.fetchall()

    # Convert your data to a format that can be easily used in the template
    videos_data = [{"title": row[0], "views": row[1]} for row in data]

    cursor.close()
    conn.close()

    return render_template('dashboard.html', videos=videos_data)


def main():
    # Connection string variables
    driver = "ODBC Driver 17 for SQL Server"
    server = "localhost"
    database = "projet_base"
    uid = "SA"
    passwd = os.getenv('DB_PASSWORD')

    # Connect to database
    cnxn = connect_to_db(driver, server, database, uid, passwd)

    # # Test database connection with simple query
    # cursor = cnxn.cursor()
    # cursor.execute("SELECT * FROM Utilisateur;")
    # rows = cursor.fetchall()
    # for row in rows:
    #     print(row)
    app.run(debug=True)


if __name__ == "__main__":
    main()