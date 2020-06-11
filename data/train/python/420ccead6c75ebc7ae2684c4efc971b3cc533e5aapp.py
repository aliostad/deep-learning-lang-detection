import core

urls = (
    '/',                            'visitor.welcome.index',
    '/earn',                        'visitor.welcome.earn',
    '/donate',                      'visitor.welcome.donate',
    '/signup',                      'visitor.account.create',
    '/login',                       'visitor.account.login',
    '/account',                     'visitor.account.display',
    '/logout',                      'visitor.account.logout',
    '/admin',                       'admin.manage.index',
    '/admin/static',                'admin.manage.static',
    '/admin/display',               'admin.manage.display',
    '/admin/getData',               'admin.manage.getData',
    '/admin/login',                 'admin.auth.login',
    '/admin/captcha.png',           'admin.auth.captcha'
)


if __name__ == "__main__":
    core.run(urls)