from django.conf import settings
from django.conf.urls import url
from django.views.decorators.cache import cache_page

cache = cache_page(60 * 15) if not settings.DEBUG else lambda x: x

from . import views

FeedbackSubmissionView_view = cache(views.FeedbackSubmissionView.as_view())
ManageCourseListView_view = views.ManageCourseListView.as_view()
ManageNotRespondedListView_view = views.ManageNotRespondedListView.as_view()
UserListView_view = views.UserListView.as_view()
UserFeedbackListView_view = views.UserFeedbackListView.as_view()
UserFeedbackView_view = views.UserFeedbackView.as_view()
RespondFeedbackView_view = views.respond_feedback_view_select(
    views.RespondFeedbackView.as_view(),
    views.RespondFeedbackViewAjax.as_view()
)
FeedbackTagView_view = views.FeedbackTagView.as_view()


PATH_REGEX = r'[\w\d\-./]'
MANAGE = r'^manage/'
MANAGE_SITE = MANAGE + r'(?P<site_id>\d+)/'


urlpatterns = [
    # Aplus feedback submission
    url(r'^feedback/$',
        FeedbackSubmissionView_view,
        name='submission'),
    url(r'^feedback/(?P<path_key>{path_regex}+)$'.format(path_regex=PATH_REGEX),
        FeedbackSubmissionView_view,
        name='submission'),

    # Feedback management and responding
    url(r'^manage/$',
        views.ManageSiteListView.as_view(),
        name='site-list'),
    url(r'^manage/courses/$',
        ManageCourseListView_view,
        name='course-list'),
    url(r'^manage/courses/(?P<site_id>\d+)/$',
        ManageCourseListView_view,
        name='course-list'),
    url(r'^manage/(?P<course_id>\d+)/clear-cache/$',
        views.ManageClearCacheView.as_view(),
        name='clear-cache'),
    url(r'^manage/(?P<course_id>\d+)/update-studenttags/$',
        views.ManageUpdateStudenttagsView.as_view(),
        name='update-studenttags'),
    url(r'^manage/(?P<course_id>\d+)/unread/$',
        ManageNotRespondedListView_view,
        name='notresponded-course'),
    url(r'^manage/(?P<course_id>\d+)/unread/(?P<path_filter>{path_regex}*)$'.format(path_regex=PATH_REGEX),
        ManageNotRespondedListView_view,
        name='notresponded-course'),
    url(r'^manage/(?P<course_id>\d+)/feedbacks/$',
        views.ManageFeedbacksListView.as_view(),
        name='list'),
    url(r'^manage/(?P<course_id>\d+)/user/$',
        UserListView_view,
        name='user-list'),
    url(r'^manage/(?P<course_id>\d+)/byuser/(?P<user_id>\d+)/$',
        UserFeedbackListView_view,
        name='byuser'),
    url(r'^manage/(?P<course_id>\d+)/byuser/(?P<user_id>\d+)/(?P<exercise_id>\d+)/$',
        UserFeedbackView_view,
        name='byuser'),
    url(r'^manage/(?P<course_id>\d+)/byuser/(?P<user_id>\d+)/(?P<exercise_id>\d+)/(?P<path_filter>{path_regex}*)$'.format(path_regex=PATH_REGEX),
        UserFeedbackView_view,
        name='byuser'),
    url(r'^manage/(?P<course_id>\d+)/tags/$',
        views.FeedbackTagListView.as_view(),
        name='tags'),
    url(r'^manage/(?P<course_id>\d+)/tags/(?P<tag_id>\d+)/$',
        views.FeedbackTagEditView.as_view(),
        name='tags-edit'),
    url(r'^manage/(?P<course_id>\d+)/tags/(?P<tag_id>\d+)/remove/$',
        views.FeedbackTagDeleteView.as_view(),
        name='tags-remove'),
    url(r'^manage/respond/(?P<feedback_id>\d+)/$',
        RespondFeedbackView_view,
        name='respond'),
    url(r'^manage/tag/(?P<feedback_id>\d+)/$',
        views.FeedbackTagView.as_view(),
        name='tag-list'),
    url(r'^manage/tag/(?P<feedback_id>\d+)/(?P<tag_id>\d+)/$',
        views.FeedbackTagView.as_view(),
        name='tag'),

    # support for old urls
    url(r'^manage/notresponded/course/(?P<course_id>\d+)/$',
         ManageNotRespondedListView_view),
    url(r'^manage/notresponded/course/(?P<course_id>\d+)/(?P<path_filter>{path_regex}*)$'.format(path_regex=PATH_REGEX),
         ManageNotRespondedListView_view),
    url(r'^manage/user/(?P<course_id>\d+)/$',
        UserListView_view),
    url(r'^manage/byuser/(?P<course_id>\d+)/(?P<user_id>\d+)/$',
        UserFeedbackListView_view),
    url(r'^manage/byuser/(?P<course_id>\d+)/(?P<user_id>\d+)/(?P<exercise_id>\d+)/$',
        UserFeedbackView_view),
    url(r'^manage/byuser/(?P<course_id>\d+)/(?P<user_id>\d+)/(?P<exercise_id>\d+)/(?P<path_filter>{path_regex}*)$'.format(path_regex=PATH_REGEX),
        UserFeedbackView_view),
]
