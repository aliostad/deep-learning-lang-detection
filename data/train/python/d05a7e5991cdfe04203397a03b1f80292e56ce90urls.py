from django.conf.urls.defaults import *

urlpatterns = patterns('',
                       # manage stuff
                       (r'^manage/programs/?$', 'esp.program.views.manage_programs'),
                       (r'^manage/newprogram/?$', 'esp.program.views.newprogram'),
                       (r'^manage/submit_transaction/?$', 'esp.program.views.submit_transaction'),
                       (r'^manage/pages/?$', 'esp.program.views.manage_pages'),
                       (r'^manage/userview/?$', 'esp.program.views.userview'),
                       (r'^manage/usersearch/?$', 'esp.program.views.usersearch'),                       
                       (r'^manage/flushcache/?$', 'esp.program.views.flushcache'),
                       (r'^manage/statistics/?$', 'esp.program.views.statistics'),
                       (r'^manage/preview/?$', 'esp.program.views.template_preview'),
                       (r'^manage/mergeaccounts/?$', 'esp.users.views.merge.merge_accounts'),
                       )
