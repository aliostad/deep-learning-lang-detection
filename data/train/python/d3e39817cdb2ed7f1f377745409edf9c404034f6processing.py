'''
The Process:

    original user input:               "twitter:rt shaq"
            ||
            \/
    parsed user input:                 "api:twitter resource:rt screen_name:shaq"
            ||
            \/
    what user really wanna query:      "[{twitter:1.0}, .. , ..]"
                                            ||
                                            \/
                                           [{api:retwitter_to_user, user:shaq}, .. , ..]
'''

api = ('twitter', 'weibo')

from apps import conn
resource = tuple({'name':_api,'res':[]} for _api in api if getattr(conn, _api, False))

for _api in resource:
    module = getattr(conn, _api['name'])
    _api['res'] = tuple(res.__name__ for res in dir(module) if isinstance(getattr(module, res), getattr(module, 'base_api')))

print resource
