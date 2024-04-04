from app.db import get_db_connection
from datetime import datetime

def fetch_videos():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Fichier')
    videos = cursor.fetchall()
    cursor.close()
    return videos

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