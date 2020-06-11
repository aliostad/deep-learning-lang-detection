from django.conf.urls import url,include
from guestmanagement import views


urlpatterns = [
        url(r'^$',views.index,name='index'),
        url(r'^guestlogin/(?P<target_guest>.+)/$',views.guestlogin,name='guestlogin'),
        url(r'^guestlogin/$',views.guestlogin,name='guestlogin'),
        url(r'^manage/(?P<target_type>.+)/(?P<target_object>.+)/',views.manage,name='manage'),
        url(r'^manage/(?P<target_type>.+)/',views.manage,name='manage'),
        url(r'^manage/$',views.manage,name='manage'),
        url(r'^view/(?P<target_type>.+)/(?P<target_object>.+)/(?P<second_object>.+)/',views.view,name='view'),
        url(r'^view/(?P<target_type>.+)/(?P<target_object>.+)/',views.view,name='view'),
        url(r'^unsetcomplete/(?P<form_id>.+)/(?P<guest_id>.+)/',views.unsetcomplete,name='unsetcomplete'),
        url(r'^setscore/(?P<form_id>.+)/(?P<guest_id>.+)/',views.setscore,name='setscore'),
        url(r'^runreport/(?P<report_id>.+)/',views.runreport,name='runreport'),
        url(r'^logout/$',views.logout,name='logout'),
        url(r'^edit/(?P<target_guest>.+)/(?P<target_form>.+)/(?P<target_guesttimedata>.+)/$',views.editpastform,name='edit'),
        url(r'^edit/(?P<target_guest>.+)/(?P<target_form>.+)/$',views.editpastform,name='edit'),
        url(r'^quickfilter/$',views.quickfilter,name='filter'),
        url(r'^reportwiki/$',views.reportwiki,name='wiki'),
]
