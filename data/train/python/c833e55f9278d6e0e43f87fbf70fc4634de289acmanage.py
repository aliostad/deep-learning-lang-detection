@auth.requires_permission('access to manage')
def index():
    '''
    management console: process pending borrow and return requests.
    '''
    response.flash = T('Welcome to management console!')
    response.files.append(URL('static','js/manage.js'))
    return dict()

@auth.requires_permission('access to manage')
def stock():
    '''
    manage stocks, add, checkin ,checkout.
    '''
    response.flash = T('Welcome to management console!')
    response.files.append(URL('static','js/manage-stock.js'))
    return dict()