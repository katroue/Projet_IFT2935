from flask import Blueprint
from ContentAnalyticsApp.app.models import fetch_videos

content = Blueprint('content_management', __name__)

@content.route('/content-management')
def show_manage_content():
    # Content logic and rendering
    return "This is the Content management page"

@content.route('/videos')
def show_videos():
    videos = fetch_videos()
    print(videos)

    return str(videos)