from flask import Blueprint

content = Blueprint('content_management', __name__)

@content.route('/content-management')
def show_manage_content():
    # Content logic and rendering
    return "This is the Content management page"
