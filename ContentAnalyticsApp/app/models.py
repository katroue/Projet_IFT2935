from app.db import get_db_connection
from datetime import datetime
from flask import session, flash
import pyodbc

def get_members():
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute('SELECT courriel, pseudo FROM Membre')
            return cursor.fetchall()

def verify_member(email, password):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute('SELECT pseudo FROM Membre WHERE courriel = ?', (email,))
            member_data = cursor.fetchone()
            cursor.execute('EXEC FetchMemberDetails')
            results = cursor.fetchall()
            for line in results:
                print(line[0].replace('\r', '\n'))

            if member_data:
                stored_password = member_data[0]
                return stored_password == password
            else:
                return False

def fetch_content():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Fichier')
    data = cursor.fetchall()
    content = [{"file_name" : row[0]} for row in data]
    cursor.close()
    return content


def remove_content(file_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = """
        DELETE FROM Fichier where nom_fichier = ?;
    """
    cursor.execute(query, (file_id))
    conn.commit()
    cursor.close()

def add_content(file_name, file_type):
    try:
        conn = get_db_connection()  # Make sure this function returns a connection object
        cursor = conn.cursor()
        query = """
            INSERT INTO Fichier (nom_fichier, type, date_ajout) VALUES
            (?, ?, CONVERT(varchar, GETDATE(), 23))
        """
        cursor.execute(query, (file_name, file_type))
        conn.commit()
    except Exception as e:
        return False
    finally:
        cursor.close()
    
    return True

def add_content_keyword(file_name, keyword):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = """ 
        IF NOT EXISTS (SELECT 1 FROM MotClé WHERE mot = ?)
            INSERT INTO MotClé (mot) VALUES (?);
    """
    cursor.execute(query, (keyword, keyword))
    conn.commit()

    query = """
        INSERT INTO AssociationMotClé (mot_clé, nom_fichier) VALUES
        (?, ?);
    """
    cursor.execute(query, (keyword, file_name))
    conn.commit()
    cursor.execute("Select * from MotClé;")
    print(cursor.fetchall())
    print()
    cursor.execute("Select * from AssociationMotClé;")
    print(cursor.fetchall())
    print()
    cursor.close()


def get_upload_trends():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT
            DAY(date_ajout) AS UploadDay,
            COUNT(*) AS NumberOfUploads
        FROM Fichier
        WHERE
            type = 'Video'
            AND MONTH(date_ajout) = 03
            AND YEAR(date_ajout) = YEAR(GETDATE())
        GROUP BY DAY(date_ajout)
        ORDER BY DAY(date_ajout);
    """)

    uploads_by_day = cursor.fetchall()
    cursor.close()

    current_year_month = datetime.now().strftime("%Y-%m")
    upload_trends = [{"date": f"{current_year_month}-{row[0]:02d}", "uploads": row[1]} for row in uploads_by_day]
    
    return upload_trends

def get_most_viewed():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('EXEC ViewCount')
    data = cursor.fetchall()
    view_counts = [{"title": row[0], "views": row[1]} for row in data]
    cursor.close()
    return view_counts

def get_average_ratings():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('EXEC GetAverageVideoRatings')  
    data = cursor.fetchall()
    average_ratings = [{"title": row[0], "average_rating": row[1]} for row in data]
    cursor.close()
    return average_ratings

def get_active_users():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("EXEC GetUserActivity")
    data = cursor.fetchall()
    user_activity = [{"Username": row[0], "RatingsCount": row[1], "UploadsCount": row[2]} for row in data]
    cursor.close()
    return user_activity