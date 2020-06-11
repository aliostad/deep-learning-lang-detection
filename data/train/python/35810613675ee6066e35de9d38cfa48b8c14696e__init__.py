import logging

from zope.sqlalchemy import ZopeTransactionExtension
from sqlalchemy import engine_from_config
from sqlalchemy.orm import scoped_session, sessionmaker

# TODO(kiall): When migrate 0.7.3 is released this can be removed.
import pyramid_sqlalchemy.migrate_patch

# NOTE(kiall): Delay importing migrate until we are patched!
from migrate.versioning import api as versioning_api
from migrate.versioning.repository import Repository
from migrate.exceptions import InvalidRepositoryError

LOG = logging.getLogger(__name__)

Session = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))
engine = None
repository = None

def db_init(engine):
    """ Initialize a fresh database and place it under version control """
    LOG.warn('Initializing database')

    if repository is None:
        LOG.warn('No valid repository found. Aborting.')
        return

    versioning_api.version_control(url=engine, repository=repository)

def db_upgrade(engine, version=None):
    """ Upgrade a database to the latest, or specified, version """
    if version is None:
        LOG.warn('Upgrading database to latest version')
    else:
        LOG.warn("Upgrading database to version '%s'" % str(version))

    if repository is None:
        LOG.warn('No valid repository found. Aborting.')
        return

    versioning_api.upgrade(url=engine, repository=repository, version=version)

def includeme(config):
    """ Set up SQLAlchemy """
    LOG.debug('Initializing SQLAlchemy session')

    global repository, engine

    settings = config.get_settings()
    engine = engine_from_config(settings, 'sqlalchemy.')

    try:
        repository = Repository(settings.get('sqlalchemy_migrate.repository', None))
    except (InvalidRepositoryError, TypeError):
        LOG.debug('Migrations disabled. No valid repository found.')
        repository = None

    Session.configure(bind=engine)
