from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView
from haystack.views import SearchView, search_view_factory
import views,views_manage, views_users

urlpatterns = patterns('',
    #url(r'^$', views.index, name='index' ),
    
    url(r'^showswf/+(?P<bookid>.*?)/*$', views.getswf, name='doc_showswf' ),
    url(r'^showpdf/+(?P<bookid>.*?)/+(?P<page>\d+)/$', views.getpdf, name='doc_showpdf' ),
    url(r'^getpdfpage/+(?P<bookid>.*?)/+(?P<page>\d+)/$', views.getpdfpage, name='doc_getpdfpage' ),
    url(r'^showhtml/+(?P<bookid>.*?)/+(?P<page>\d+)/$', views.gethtml, name='doc_showhtml' ),
    url(r'^gethtmlpage/+(?P<bookid>.*?)/+(?P<page>\d+)/$', views.gethtmlpage, name='doc_gethtmlpage' ),

    url(r'^view/+(?P<bookid>.*?)/*$', views.view, name='doc_view' ),
    url(r'^directview/+(?P<path>.*)/$', views.directview, name='doc_directview' ),
    url(r'^pdfviewer/', TemplateView.as_view(template_name="pdfviewer.html") ),
    url(r'^history/*$', views.viewhistory, name='doc_viewhistory' ),

    url(r'^search/$', search_view_factory(view_class=views.BookSearchView, load_all=False, template='search/search.html', form_class=views.BookSearchForm), name='doc_search'),
    
    
    url(r'^manage/book/$', views_manage.booklist, name='doc_manage_index' ),
    url(r'^manage/bookupload/$', views_manage.upload, name='doc_manage_upload' ),
    url(r'^manage/bookedit/+(?P<bookid>.*)/$', views_manage.bookedit, name='doc_manage_bookedit' ),
    url(r'^manage/bookdelete/+(?P<bookid>.*)/$', views_manage.bookdelete, name='doc_manage_bookdelete' ),
    url(r'^manage/pdfregen/+(?P<bookid>.*)/$', views_manage.pdfregen, name='doc_manage_pdfregen' ),

    url(r'^manage/user/$', views_manage.userlist, name='user_manage_index' ),
    url(r'^manage/useredit/+(?P<userid>.*)/$', views_manage.useredit, name='manage_useredit' ),
    url(r'^manage/userdelete/+(?P<userid>.*)/$', views_manage.userdelete, name='manage_userdelete' ),


    url(r'^user/register/+(?P<regtype>.*?)/*$', views_users.register, name='user_register' ),
    url(r'^user/addfav/+(?P<bookid>.*?)/$', views_users.addfavorite, name='user_addfavorite' ),
    url(r'^user/myfavorite/$', views_users.myfavorite, name='user_myfavorite' ),
    url(r'^user/myfavorite/remove/+(?P<id>\d+)/$', views_users.removefavorite, name='user_removefavorite' ),
    url(r'^user/myspace/$', TemplateView.as_view(template_name="user/myspace.html") ),


    url(r'^login/+@*(?P<path>.*)$', views.login, name='login' ),
    url(r'^logout/$', views.logout, name='logout' ),
    
    url(r'^classview/+(?P<path>.*)$', views.classview, name='doc_classview' ),
    
    
    url(r'^test/testpdf/$', TemplateView.as_view(template_name="test.html") ),
    url(r'^test/getpdf/+(?P<bookid>.*?)/+(?P<page>\d+)/$' , views.testgetpdf, name='doc_getpdf' ),
)
