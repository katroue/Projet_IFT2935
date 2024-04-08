from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from app.models import verify_member

auth = Blueprint('auth', __name__)

@auth.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        if verify_member(email, password):
            session['user_is_authenticated'] = True
            session['user_email'] = email
            return redirect(url_for('dashboard.show_dashboard'))
        else:
            flash('Invalid email or password')
            session['user_is_authenticated'] = False
    return render_template('login.html')

@auth.route('/logout')
def logout():
    session.pop('user_is_authenticated', None)  # Clear the authentication flag
    session.pop('user_email', None)  # Clear the user email
    return redirect(url_for('auth.login'))

@auth.route('/')
def home():
    session['user_is_authenticated'] = False
    return render_template("base.html")