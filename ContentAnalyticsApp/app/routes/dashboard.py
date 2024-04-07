import json
from flask import Blueprint, render_template
from ContentAnalyticsApp.app.models import get_most_viewed, get_upload_trends, get_average_ratings, get_active_users

dashboard = Blueprint('dashboard', __name__)

@dashboard.route('/dashboard')
def show_dashboard():
    # Dashboard logic and rendering
    upload_trends = get_upload_trends()
    most_viewed = get_most_viewed()
    average_ratings = get_average_ratings()
    active_users = get_active_users()

    return render_template('dashboard.html', 
                            most_viewed=json.dumps(most_viewed), 
                            upload_trends=json.dumps(upload_trends),
                            average_ratings=json.dumps(average_ratings),
                            user_activity=json.dumps(active_users))
