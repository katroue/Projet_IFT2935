import json
from flask import Blueprint, render_template
from app.models import get_most_viewed, get_upload_trends

dashboard = Blueprint('dashboard', __name__)

@dashboard.route('/dashboard')
def show_dashboard():
    # Dashboard logic and rendering
    upload_trends = get_upload_trends()
    most_viewed = get_most_viewed()
    # average_ratings = get_average_ratings()
    # active_users = get_active_users()
    print(upload_trends)

    # return render_template('dashboard.html', 
    #                        upload_trends=upload_trends,
    #                        most_viewed=most_viewed,
    #                        average_ratings=average_ratings,
    #                        active_users=active_users)
    return render_template('dashboard.html', most_viewed=json.dumps(most_viewed), upload_trends=json.dumps(upload_trends))
