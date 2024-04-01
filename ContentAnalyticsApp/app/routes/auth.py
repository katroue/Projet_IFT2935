from flask import Blueprint

auth = Blueprint('auth', __name__)

@auth.route('/login')
def login():
    # Login logic and rendering
    return "This is the login"
