from flask import Flask

def create_app():
    app = Flask(__name__)

    from .routes.auth import auth as auth_blueprint
    app.register_blueprint(auth_blueprint)

    from .routes.dashboard import dashboard as dashboard_blueprint
    app.register_blueprint(dashboard_blueprint)

    from .routes.content_management import content as content_blueprint
    app.register_blueprint(content_blueprint)

    return app