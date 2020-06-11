import inject
import os

def config(settings):
    """Initialize Dependency Injection

    :param settings: Application settings
    :type settings: Settings
    """
    injector = inject.Injector()

    injector.bind('service_user', to=service_user, scope=inject.appscope)
    injector.bind('repository_user', to=repository_user, scope=inject.appscope)

    injector.bind('service_document', to=service_document, scope=inject.appscope)
    injector.bind('repository_document', to=repository_document, scope=inject.appscope)

    injector.bind('settings', to=settings, scope=inject.noscope)
    inject.register(injector)

@inject.param("repository_user")
def service_user(repository_user):
    from library.bas.services.users import Users
    return Users(repository_user)

def repository_user():
    from library.bas.repository.users import Users
    return Users()

@inject.param("repository_document")
def service_document(repository_document):
    from library.bas.services.documents import Documents
    return Documents(repository_document)

def repository_document():
    from library.bas.repository.documents import Documents
    return Documents()
