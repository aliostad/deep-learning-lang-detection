from django.conf.urls.defaults import *
from django.conf import settings
import views

import dselector
parser = dselector.Parser()
url = parser.url

urlpatterns = parser.patterns('',                      
    url(r'{volunteer_id:digits}/save-completed-shift$',         views.save_completed_volunteer_shift,                 name='save_completed_volunteer_shift'),
	url(r'{volunteer_shift_id:digits}/delete-shift$',     	  	views.delete_completed_volunteer_from_people_tab,     name='delete_completed_volunteer_from_people_tab'),
	url(r'{volunteer_id:digits}/save-status-skills$',         	views.save_status,                 		              name='save_status'),    	
)