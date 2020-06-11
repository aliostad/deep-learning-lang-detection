from .interfaces import IAuthenticator
from .authenticator import RepositoryAuthenticator
from .models import User, init
from rebecca.repository.sqla import SQLARepository


def includeme(config):
    config.include('rebecca.repository')
    init()
    db_session = config.registry.settings.get('rebecca.users.db_session')
    db_session = config.maybe_dotted(db_session)
    user_model = config.registry.settings.get('rebecca.users.user_model',
                                              User)
    user_model = config.maybe_dotted(user_model)
    user_repository = SQLARepository(
        user_model, user_model.username, db_session)

    config.add_repository(user_repository,
                          name='user')
    config.registry.registerUtility(RepositoryAuthenticator(user_repository),
                                    IAuthenticator)
