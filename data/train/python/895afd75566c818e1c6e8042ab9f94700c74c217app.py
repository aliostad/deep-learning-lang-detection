import	web

web.config.dbpath = "sqlite:///db/app.db"
#web.config.debug = False

### Url mappings

urls = (
	'/', 'controllers.main_controller.Index',
	'/archives', 'controllers.main_controller.Archives',
	'/archives/(.+)/(.+)/(.+)/(.+)', 'controllers.main_controller.ArchivePageYearMonthDay', 	
	'/archives/(.+)/(.+)/(.+)', 'controllers.main_controller.ArchivePageYearMonth',
	'/archives/(.+)/(.+)', 'controllers.main_controller.ArchivePageYear',
	'/archives/(.+)', 'controllers.main_controller.ArchivePage', 	 
	'/contact', 'controllers.main_controller.Contact',
	'/posts', 'controllers.main_controller.Index',
	'/posts/(.+)', 'controllers.main_controller.PostSlug',
	'/topics/(.+)/(.+)', 'controllers.main_controller.Topic',
	'/search', 'controllers.main_controller.Search', 		
	
	'/admin', 'controllers.admin_controller.Index',
	
	'/admin/posts/new', 'controllers.admin_controller.NewPost',
	'/admin/posts/edit/(.+)', 'controllers.admin_controller.EditPost',
	'/admin/posts/destroy/(.+)', 'controllers.admin_controller.DeletePost',
	'/admin/posts', 'controllers.admin_controller.Posts', 	
	'/admin/posts/(.+)', 'controllers.admin_controller.Posts', 	
	 
	'/admin/pages/new', 'controllers.admin_controller.NewPage',
	'/admin/pages/edit/(.+)', 'controllers.admin_controller.EditPage',
	'/admin/pages/destroy/(.+)', 'controllers.admin_controller.DeletePage',	
	'/admin/pages', 'controllers.admin_controller.Pages',
	'/admin/pages/(.+)', 'controllers.admin_controller.Pages', 	
	 
	'/admin/topics', 'controllers.admin_controller.Topics',
	'/admin/topics/destroy/(.+)', 'controllers.admin_controller.DeleteTopic',
	
	'/admin/settings', 'controllers.admin_controller.Settings',
	 
	'/sitemap.xml', 'controllers.api_controller.Sitemap',
	'/sitemap', 'controllers.api_controller.Sitemap',
	'/sitemap.xsd', 'controllers.api_controller.Sitemap',
	'/sitemap.xsl', 'controllers.api_controller.SitemapStyle',
	'/rsd.xml', 'controllers.api_controller.Rsd',
	'/rsd.axd', 'controllers.api_controller.Rsd',
	'/wlwmanifest.xml', 'controllers.api_controller.Wlwmanifest',
	'/metaweblog.xml', 'controllers.api_controller.Metaweblog',
	'/feed.xml', 'controllers.api_controller.Feed',
	'/feed', 'controllers.api_controller.Feed',
	'/opensearch.axd', 'controllers.api_controller.Opensearch',
	'/opensearch', 'controllers.api_controller.Opensearch',
	'/robots.txt', 'controllers.api_controller.Robots',
	'/robots', 'controllers.api_controller.Robots',
	'/(.+)', 'controllers.main_controller.PageSlug'
)



app = web.application(urls, globals())

from controllers import main_controller
app.notfound = main_controller.notfound
app.internalerror = main_controller.internalerror

#application = app.wsgifunc()

if __name__ == '__main__':
	app.run()
