from giga_web import giga_web
from .userapi import UserAPI
from .projectapi import ProjectAPI
from .pledgeapi import PledgeAPI
from .organizationapi import OrganizationAPI
from .transactionapi import TransactionAPI
from .marketinglistapi import MarketingListAPI
from .contactapi import ContactAPI

app = giga_web


def register_api(view, endpoint, url, pk='id'):
    view_func = view.as_view(endpoint)
    #if endpoint in ['client_api', 'user_api', 'email_list_api']:
    app.add_url_rule(url, defaults={pk: None},
                         view_func=view_func, methods=['GET', ])
    # if endpoint not in ['organization_api', 'user_api']:
    #     app.add_url_rule('/<cid>' + url, defaults={pk: None},
    #                      view_func=view_func, methods=['GET', ])
    if endpoint == 'project_api':
        app.add_url_rule(url + '<org_perma>/<proj_perma>/', defaults={pk: None},
                         view_func=view_func, methods=['GET'])

    app.add_url_rule(url, view_func=view_func, methods=['POST', ])
    app.add_url_rule('%s<%s>' % (url, pk), view_func=view_func,
                     methods=['GET', 'PUT', 'DELETE'])

register_api(UserAPI, 'user_api', '/users/')
register_api(PledgeAPI, 'pledge_api', '/pledges/')
register_api(ProjectAPI, 'project_api', '/projects/')
register_api(OrganizationAPI, 'organization_api', '/organizations/')
register_api(TransactionAPI, 'transaction_api', '/transactions/')
register_api(MarketingListAPI, 'marketing_list_api', '/marketing_lists/')
register_api(ContactAPI, 'contact_api', '/marketing_lists/<ml_id>/contacts/')
