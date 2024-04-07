from app import create_app

app = create_app()

@app.context_processor
def inject_user_status():
    from flask import session
    return {'user_is_authenticated': session.get('user_is_authenticated', False)}

if __name__ == '__main__':
    app.run(debug=True)