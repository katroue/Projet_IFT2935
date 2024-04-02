from app.db import get_db_connection

def fetch_videos():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Fichier')
    videos = cursor.fetchall()
    cursor.close()
    return videos

def get_upload_trends():
    pass

def get_most_viewed():
    pass

def get_average_ratings():
    pass

def get_active_users():
    pass