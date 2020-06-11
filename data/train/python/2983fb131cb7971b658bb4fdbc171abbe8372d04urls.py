#!/usr/bin/python
# -*- coding: utf-8 -*-
from django.conf.urls.defaults import *

# Uncomment the next two lines to enable the admin:

from django.contrib import admin
admin.autodiscover()
urlpatterns = patterns(  # Example:
                         # Uncomment the admin/doc line below and add 'django.contrib.admindocs'
                         # to INSTALLED_APPS to enable admin documentation:
                         # (r'^admin/doc/', include('django.contrib.admindocs.urls')),
                         # Uncomment the next line to enable the admin:
    r'',
    (r'^klp/', include('schools.urls')),
    (r'^admin/', include(admin.site.urls)),
    (r'^static_media/(?P<path>.*)$', 'django.views.static.serve',
     {'document_root': 'static_media'}),
    url(r'', include(r'klprestApi.HomeApi')),
    url(r'', include(r'klprestApi.TreeMenu')),
    url(r'', include(r'klprestApi.BoundaryApi')),
    url(r'', include(r'klprestApi.InstitutionApi')),
    url(r'', include(r'klprestApi.InstitutionCategoryApi')),
    url(r'', include(r'klprestApi.InstitutionManagementApi')),
    url(r'', include(r'klprestApi.LanguageApi')),
    url(r'', include(r'klprestApi.ProgrammeApi')),
    url(r'', include(r'klprestApi.AssessmentApi')),
    url(r'', include(r'klprestApi.QuestionApi')),
    url(r'', include(r'klprestApi.StudentGroupApi')),
    url(r'', include(r'klprestApi.StudentApi')),
    url(r'', include(r'klprestApi.AuthenticationApi')),
    url(r'', include(r'klprestApi.AnswerApi')),
    url(r'', include(r'klprestApi.StaffApi')),
    url(r'', include(r'klprestApi.ConsoleApi')),
    url(r'', include(r'klprestApi.KLP_Permission')),
    url(r'', include(r'klprestApi.KLP_UserApi')),
    url(r'', include(r'klprestApi.KLP_Map')),
    url(r'', include(r'klprestApi.KLP_AuditTrial')),
    url(r'', include(r'klprestApi.AllidsActivate')),
    url(r'', include(r'klprestApi.KLP_Common')),
    )
