from flask import Blueprint, render_template

auth = Blueprint('auth', __name__)

@auth.route('/login')
def login():
    # Login logic and rendering
    return render_template('login.html')

@auth.route('/')
def home():
    return render_template("base.html")