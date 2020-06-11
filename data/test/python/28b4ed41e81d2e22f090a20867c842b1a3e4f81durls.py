from django.conf.urls import url
from views import ApiController, ApiAuthenticationController
from models import User, Track, Collaborator, File, Agreement, Comment

user_controller = ApiController(User, name='user')
track_controller = ApiController(Track, name='track', parent_model=User, parent_name='user')
collaborator_controller = ApiController(Collaborator, name='collaborator', parent_model=Track)
file_controller = ApiController(File, name='file', parent_model=Track)
agreement_controller = ApiController(Agreement, name='agreement', parent_model=Track)
comment_controller = ApiController(Comment, name='comment', parent_model=Track)
authentication_controller = ApiAuthenticationController(User)


PROTECTED_ROUTES = {
    'GET': [r'^users/?$'],
    'ALL': [r'^users/(?P<user_id>[0-9]+)$', r'^tracks/'],
    'POST': [],
    'PUT': [],
    'PATCH': []
}


urlpatterns = [
    url(r'^login/?$', authentication_controller.authenticate),
    url(r'^users/?$', user_controller.all_or_authenticate),
    url(r'^users/(?P<user_id>[0-9]+)$', user_controller.single),
    url(r'^tracks/?$', track_controller.all),
    url(r'^tracks/(?P<track_id>[0-9]+)$', track_controller.single),
    url(r'^tracks/(?P<track_id>[0-9]+)/collaborators/?$', collaborator_controller.nested_all),
    url(r'^tracks/(?P<track_id>[0-9]+)/collaborators/(?P<collaborator_id>[0-9]+)/?$', collaborator_controller.single),
    url(r'^tracks/(?P<track_id>[0-9]+)/files/?$', file_controller.nested_all),
    url(r'^tracks/(?P<track_id>[0-9]+)/files/(?P<file_id>[0-9]+)/?$', file_controller.single),
    url(r'^tracks/(?P<track_id>[0-9]+)/agreements$', agreement_controller.nested_all),
    url(r'^tracks/(?P<track_id>[0-9]+)/agreements/(?P<file_id>[0-9]+)/?$', agreement_controller.single),
    url(r'^tracks/(?P<track_id>[0-9]+)/comments/?$', comment_controller.nested_all),
    url(r'^tracks/(?P<track_id>[0-9]+)/comments/(?P<file_id>[0-9]+)/?$', comment_controller.single),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/?$', track_controller.nested_all),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/(?P<track_id>[0-9]+)$', track_controller.single),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/(?P<track_id>[0-9]+)/collaborators/?$', collaborator_controller.nested_all),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/(?P<track_id>[0-9]+)/collaborators/(?P<collaborator_id>[0-9]+)/?$', collaborator_controller.single),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/(?P<track_id>[0-9]+)/files/?$', file_controller.nested_all),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/(?P<track_id>[0-9]+)/files/(?P<file_id>[0-9]+)/?$', file_controller.single),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/(?P<track_id>[0-9]+)/agreements$', agreement_controller.nested_all),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/(?P<track_id>[0-9]+)/agreements/(?P<agreement_id>[0-9]+)/?$', agreement_controller.single),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/(?P<track_id>[0-9]+)/comments/?$', comment_controller.nested_all),
    url(r'^users/(?P<user_id>[0-9]+)/tracks/(?P<track_id>[0-9]+)/comments/(?P<comment_id>[0-9]+)/?$', comment_controller.single),
]


# def build_urls(resources, **controllers):
#     built = []
#
#     show = r'^'
#     for route in resources[:-1]:
#         show + re.escape(route) + r'/(?P<' + re.escape(route + '_id') + r'>[0-9]+)$/'
#     show + re.escape(resources[-1]) + r'/(?P<' + re.escape(resources[-1] + '_id') + r'>[0-9]+)/?$'
#     built.append(url(show, controllers.get('single')))
#
#     ind = r'^'
#     for route in resources[:-1]:
#         ind + re.escape(route) + r'/(?P<' + re.escape(route + '_id') + r'>[0-9]+)$/'
#     ind + re.escape(resources[-1]) + r'/?$'
#     built.append(url(ind, controllers.get('all')))