__auther__ = 'fohnwind'

from fae import create_app
from flask import current_app
from flask_script import Manager, Server,Shell
from flask_migrate import MigrateCommand, upgrade
from fae.extensions import db

try:
    from fae.configs.development import DevelopmentConfig as Config
except ImportError:
    from fae.configs.default import DefaultConfig as Config

app = create_app(Config)
manage = Manager(app)

manage.add_command("runserver", Server("0.0.0.0", port=5555,))

manage.add_command('db', MigrateCommand)


@manage.command
def initdb():
    """Create the database."""

    upgrade()


@manage.command
def dropdb():
    """Delete the database."""

    db.drop_all()

if __name__ == "__main__":
    manage.run()