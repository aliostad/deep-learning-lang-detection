from django.conf.urls import patterns, include, url
from django.contrib import admin

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'pool.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),

    # user apis
    url(r'^api/register$', 'api.user.register'),
    url(r'^api/login$', 'api.user.login'),
    url(r'^api/logout$', 'api.user.logout'),
    url(r'^api/modify_password$', 'api.user.modify_password'),

    # question pool apis
    url(r'^api/get_dicipline$', 'api.question.get_diciplines'),
    url(r'^api/get_category$', 'api.question.get_categories'),
    url(r'^api/get_types$', 'api.question.get_types'),
    url(r'^api/get_questions$', 'api.question.get_questions'),
    url(r'^api/modify_question$', 'api.question.modify_question'),
    url(r'^api/get_tags$', 'api.question.get_tags'),
    url(r'^api/add_tag$', 'api.question.add_tag'),
    url(r'^api/remove_tag$', 'api.question.remove_tag'),
    #url(r'^.*$', 'api.utils.index'),
)
