from django.conf.urls.defaults import *

from views import * 

urlpatterns = patterns('',
    url(r'^user/$', api_user, name='api_user'),
    url(r'^forum/$', api_forum, name='api_forum'),    
    url(r'^forums/$', api_forums, name='api_forums'),    
    url(r'^authentication/$', api_authentication, name='api_authentication'),        
    url(r'^annotations/$', api_annotations, name='api_annotations'),   
    url(r'^annotation/$', api_annotation, name='api_annotation'),   
    url(r'^map/$', api_map, name='api_map'),   
    url(r'^timeline/$', api_timeline, name='api_timeline'),   
    url(r'^threads/$', api_threads, name='api_threads'),   
    # urls for compability support with previous version
    url(r'^User/$', api_user, name='api_user'),
    url(r'^Group/$', api_forum, name='api_forum'),    
    url(r'^Groups/$', api_forums, name='api_forums'),        
    url(r'^Login/$', api_authentication, name='api_authentication'),        
    url(r'^Annotations/$', api_annotations, name='api_annotations'),                
    url(r'^Annotation/$', api_annotation, name='api_annotation'),   
    url(r'^Map/$', api_map, name='api_map'),   
    url(r'^Timeline/$', api_timeline, name='api_timeline'),
    url(r'^Threads/$', api_threads, name='api_threads'),              
)

