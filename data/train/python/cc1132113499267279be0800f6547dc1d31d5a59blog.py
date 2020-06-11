#!C:\Python26\python.exe -u
#coding:utf-8
import web
import views
web.config.debug = False

urls = (
    '/', 'views.default',#/?p=23
    '/\d{4}/\d{1,2}/\d{2}/([^/]+)\.html','views.article_by_slug',
    '/(\d{4})/(\d{2})','views.article_by_month',
    '/(\d{4})','views.article_by_year',
    '/category/(.*)','views.article_by_category',
    '/post_comment','views.post_comment',    
    '/tag/(.*)','views.article_by_tag',
    '/feed','views.feed',
    '/error/(\d+)','views.error',
    '/(.*)/', 'views.redirect',
    '/notfound','views.notfound',
    '/media/([^/]*)/{0,1}.*','views.get_media',
    '/login','views.login',
    '/logout','views.logout',
    
    '/manage','views.manage_config',
    '/manage/article','views.manage_article',
    '/manage/article/edit','views.manage_article_edit',
    '/manage/article/del','views.manage_article_del',
    '/manage/comments','views.manage_comments',
    '/manage/comments/del','views.manage_comments_del',
    '/manage/category','views.manage_category',
    '/manage/category/edit','views.manage_category_edit',
    '/manage/category/del','views.manage_category_del',
    '/manage/users','views.manage_users',
    '/manage/users/edit','views.manage_users_edit',
    '/manage/users/del','views.manage_users_del',
    '/manage/config','views.manage_config',
    '/manage/links','views.manage_links',
    '/manage/links/edit','views.manage_links_edit',
    '/manage/links/del','views.manage_links_del',
    '/manage/media','views.manage_media',
    '/manage/media/del','views.manage_media_del',
    '/manage/upload','views.manage_upload'
)
app = web.application(urls, globals())
app.notfound = views.notfound

if web.config.get('_session') is None:
    web.config._session = web.session.Session(app, web.session.DiskStore('sessions'), {'logged': False,'accountname':'','dispname':'',"id":0,"isadmin":False})
    

if __name__ == '__main__':
    app.run()