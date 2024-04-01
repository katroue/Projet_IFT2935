from flask import Blueprint

dashboard = Blueprint('dashboard', __name__)

@dashboard.route('/dashboard')
def show_dashboard():
    # Dashboard logic and rendering
    return "This is the dashboard"
