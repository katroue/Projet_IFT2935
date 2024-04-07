from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from ContentAnalyticsApp.app.models import verify_member

auth = Blueprint('auth', __name__)

@auth.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        print("yoyoyoyoyoyo")
        if verify_member(email, password):
            session['user_email'] = email
            return redirect(url_for('dashboard.show_dashboard'))
        else:
            flash('Invalid email or password')

    return render_template('login.html')
@auth.route('/')
def home():
    return render_template("base.html")