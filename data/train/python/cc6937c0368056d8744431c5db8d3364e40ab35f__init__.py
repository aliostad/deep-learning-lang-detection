from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy
from pyramid.config import Configurator
from pyramid_beaker import session_factory_from_settings
from vanity_app.resources import Root
from vanity_app.utils import buildout


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    authentication_policy = AuthTktAuthenticationPolicy('')
    authorization_policy = ACLAuthorizationPolicy()
    session_factory = session_factory_from_settings(settings)
    config = Configurator(root_factory=Root, settings=settings,
        authentication_policy=authentication_policy,
        authorization_policy=authorization_policy,
        session_factory=session_factory)
    # Static files
    config.add_static_view('deform_static', 'deform:static')
    config.add_static_view('static', 'vanity_app:static', cache_max_age=3600)
    config.add_route('favicon', '/favicon.ico')
    config.add_view('vanity_app.views.favicon', route_name='favicon')
    config.add_route('google_verify', '')
    config.add_view('vanity_app.views.google_verify',
        route_name='google_verify')
    config.add_route('robots', '/robots.txt')
    config.add_view('vanity_app.views.robots', route_name='robots')
    config.add_route('humans', '/humans.txt')
    config.add_view('vanity_app.views.humans', route_name='humans')
    # Customize 40x
    config.add_view('vanity_app.views.vanity_403',
        context='pyramid.exceptions.Forbidden',
        renderer='vanity_app:templates/vanity_403.mak')
    config.add_view('vanity_app.views.vanity_404',
        context='pyramid.exceptions.NotFound',
        renderer='vanity_app:templates/vanity_404.mak')
    # Configure / and /about
    config.add_view('vanity_app.views.vanity_root',
        context='vanity_app:resources.Root',
        renderer='vanity_app:templates/vanity_root.mak')
    config.add_route('vanity_about', '/about')
    config.add_view('vanity_app.views.vanity_about',
        route_name='vanity_about',
        renderer='vanity_app:templates/vanity_about.mak')
    config.add_route('home_of_the_one_click_release', '/ONE_CLICK_RELEASE')
    config.add_route('one_click', '/ONE_CLICK')
    config.add_view('vanity_app.views.one_click', route_name='one_click')
    config.add_view('vanity_app.views.home_of_the_one_click_release',
        route_name='home_of_the_one_click_release')
    # Configure /activity
    config.add_route('vanity_activity', '/activity')
    config.add_view('vanity_app.views.vanity_activity',
        route_name='vanity_activity',
        renderer='vanity_app:templates/vanity_activity.mak')
    # Configure /buildout
    path = buildout()
    config.add_route('buildout_redir', '/buildout')
    config.add_view('vanity_app.views.buildout_redir',
        route_name='buildout_redir')
    config.add_static_view(name='buildout', path=path)
    config.add_route('buildout_software_version',
        '/build/{software}/{version}')  # redir
    config.add_route('buildout_software_version_filename',
        '/build/{software}/{version}/{filename}')
    config.add_view('vanity_app.views.buildout_software_version',
        route_name='buildout_software_version')
    config.add_view('vanity_app.views.buildout_software_version_filename',
        route_name='buildout_software_version_filename')
    # Configure /contact
    config.add_route('contact', '/contact')
    config.add_view('vanity_app.views.contact',
        route_name='contact',
        renderer='vanity_app:templates/contact.mak')
    # Login/logout
    config.add_route('vanity_login', '/login')
    config.add_view('vanity_app.views.login', route_name='vanity_login',
        renderer='vanity_app:templates/vanity_login.mak')
    config.add_route('vanity_logout', '/logout')
    config.add_view('vanity_app.views.logout', route_name='vanity_logout')
    # Configure /dashboard
    config.add_route('dashboard', '/dashboard')
    config.add_view('vanity_app.views.dashboard',
        route_name='dashboard',
        renderer='vanity_app:templates/dashboard.mak',
        permission='manage_dashboard')
    # Configure /github
    config.add_route('github', '/github')
    config.add_view('vanity_app.views.github', route_name='github')
    # Configure /manage/*
    config.add_route('manage_github_orgs',
        '/manage/github-orgs')
    config.add_view('vanity_app.views.manage_github_orgs',
        route_name='manage_github_orgs',
        renderer='vanity_app:templates/manage_github_orgs.mak',
        permission='manage_package')
    config.add_route('manage_github_orgs_add',
        '/manage/github-orgs/add')
    config.add_view('vanity_app.views.manage_github_orgs_add',
        route_name='manage_github_orgs_add',
        renderer='vanity_app:templates/manage_github_orgs_add.mak',
        permission='manage_package')
    config.add_route('manage_github_orgs_clear',
        '/manage/github-orgs/clear')
    config.add_view('vanity_app.views.manage_github_orgs_clear',
        route_name='manage_github_orgs_clear',
        permission='manage_package')
    config.add_route('manage_account_github',
        '/manage/account/github')
    config.add_view('vanity_app.views.manage_account_github',
        route_name='manage_account_github',
        renderer='vanity_app:templates/manage_account_github.mak',
        permission='manage_package')
    config.add_route('manage_account_pypi', '/manage/account/pypi')
    config.add_view('vanity_app.views.manage_account_pypi',
        route_name='manage_account_pypi',
        renderer='vanity_app:templates/manage_account_pypi.mak',
        permission='manage_package')
    config.add_route('manage_billing', '/manage/billing')
    config.add_view('vanity_app.views.manage_billing',
        route_name='manage_billing',
        renderer='vanity_app:templates/manage_billing.mak',
        permission='manage_package')
    config.add_route('manage_mail', '/manage/mail')
    config.add_view('vanity_app.views.manage_mail',
        route_name='manage_mail',
        renderer='vanity_app:templates/manage_mail.mak',
        permission='manage_site')
    config.add_route('manage_twitter', '/manage/twitter')
    config.add_view('vanity_app.views.manage_twitter',
        route_name='manage_twitter',
        renderer='vanity_app:templates/manage_twitter.mak',
        permission='manage_site')
    config.add_route('manage_package', '/manage/package')
    config.add_view('vanity_app.views.manage_package',
        route_name='manage_package',
        renderer='vanity_app:templates/manage_package.mak',
        permission='manage_package')
    config.add_route('manage_package_new', '/manage/package/new')
    config.add_view('vanity_app.views.manage_package_new',
        route_name='manage_package_new',
        renderer='vanity_app:templates/manage_package_new.mak',
        permission='manage_package')
    config.add_route('manage_package_add', '/manage/package/add')
    config.add_view('vanity_app.views.manage_package_add',
        route_name='manage_package_add',
        renderer='vanity_app:templates/manage_package_add.mak',
        permission='manage_package')
    config.add_route('manage_package_bulk', '/manage/package/bulk')
    config.add_view('vanity_app.views.manage_package_bulk',
        route_name='manage_package_bulk',
        renderer='vanity_app:templates/manage_package_bulk.mak',
        permission='manage_package')
    config.add_route('manage_package_clear', '/manage/package/clear')
    config.add_view('vanity_app.views.manage_package_clear',
        route_name='manage_package_clear',
        permission='manage_package')
    # Configure /signup
    config.add_route('vanity_signup', '/signup')
    config.add_view('vanity_app.views.vanity_signup',
        route_name='vanity_signup',
        renderer='vanity_app:templates/vanity_signup.mak')
    # Configure /package/{package}
    config.add_route('vanity_info_package', '/info/{package}')
    config.add_view('vanity_app.views.vanity_info_package',
        route_name='vanity_info_package')
    config.add_route('vanity_pypi_package', '/pypi/{package}')
    config.add_view('vanity_app.views.vanity_pypi_package',
        route_name='vanity_pypi_package')
    config.add_route('vanity_package', '/package/{package}')
    config.add_view('vanity_app.views.vanity_package',
        route_name='vanity_package',
        renderer='vanity_app:templates/vanity_package.mak')
    # Configure /plans
    config.add_route('plans', '/plans')
    config.add_view('vanity_app.views.plans',
        route_name='plans',
        renderer='vanity_app:templates/plans.mak')
    # Configure /user/<user> and /users
    config.add_route('vanity_user', '/user/{user}')
    config.add_view('vanity_app.views.vanity_user',
        route_name='vanity_user',
        renderer='vanity_app:templates/vanity_user.mak')
    config.add_route('vanity_users', '/users')
    config.add_view('vanity_app.views.vanity_users',
        route_name='vanity_users',
        renderer='vanity_app:templates/vanity_users.mak')
    return config.make_wsgi_app()
