from errors import FMConfigError


base_url = 'https://www.filemail.com'

api_urls = {
    'login': ['get', 'api/authentication/login'],
    'logout': ['get', 'api/authentication/logout'],
    'init': ['get', 'api/transfer/initialize'],
    'get': ['get', 'api/transfer/get'],
    'get_sent': ['get', 'api/transfer/sent/get'],
    'complete': ['get', 'api/transfer/complete'],
    'forward': ['get', 'api/transfer/forward'],
    'share': ['get', 'api/transfer/share'],
    'cancel': ['get', 'api/transfer/cancel'],
    'delete': ['get', 'api/transfer/delete'],
    'compress': ['get', 'api/transfer/compress'],
    'file_rename': ['get', 'api/transfer/file/rename'],
    'file_delete': ['get', 'api/transfer/file/delete'],
    'update': ['get', 'api/transfer/update'],
    'received_get': ['get', 'api/transfer/received/get'],
    'user_get': ['get', 'api/user/get'],
    'user_update': ['get', 'api/user/update'],
    'contacts_get': ['get', 'api/contacts/get'],
    'contacts_add': ['get', 'api/contacts/add'],
    'contacts_update': ['get', 'api/contacts/update'],
    'contacts_delete': ['get', 'api/contacts/delete'],
    'contacts_add_to_group': ['get', 'api/contacts/addtogroup'],
    'contacts_remove_from_group': ['get', 'api/contacts/removefromgroup'],
    'groups_get': ['get', 'api/contacts/group/get'],
    'group_add': ['get', 'api/contacts/group/add'],
    'group_update': ['get', 'api/contacts/group/update'],
    'group_delete': ['get', 'api/contacts/group/delete'],
    'company_get': ['get', 'api/company/get'],
    'company_update': ['get', 'api/company/update'],
    'company_get_users': ['get', 'api/company/user/getall'],
    'company_add_user': ['get', 'api/company/user/add'],
    'company_update_user': ['get', 'api/company/user/update']
    }


def get_URL(action):
    if action in api_urls:
        method, url = api_urls[action]
        url = '/'.join((base_url, url))
        return method, url

    raise FMConfigError('You passed an invalid action: {}'.format(action))
