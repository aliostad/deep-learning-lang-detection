"""Routes configuration

The more specific and detailed routes should be defined first so they
may take precedent over the more generic routes. For more information
refer to the routes manual at http://routes.groovie.org/docs/
"""
from pylons import config
from routes import Mapper

def make_map():
    """Create, configure and return the routes Mapper"""
    map = Mapper(directory=config['pylons.paths']['controllers'],
                 always_scan=config['debug'], explicit=True)
    map.minimization = False

    # The ErrorController route (handles 404/500 error pages); it should
    # likely stay at the top, ensuring it can always be resolved
    map.connect('/error/{action}', controller='error')
    map.connect('/error/{action}/{id}', controller='error')

    # CUSTOM ROUTES HERE
    map.connect('/', controller='post', action='home')
    map.connect('/blog', controller='post', action='blog')
    
    """Administrative actions
    """
    map.connect('/admin/dashboard', 
                controller='account', 
                action='dashboard')
    
    map.connect('/signout', 
                controller='account', 
                action='signout')
    
    map.connect('/admin/signin', 
                controller='account', 
                action='signinagain')
    
    map.connect('/admin/{controller}/new',
                controller='{controller}',
                action='new'
                )
    map.connect('/admin/{controller}/create',
                controller='{controller}',
                action='create'
                )
    map.connect('/admin/{controller}/edit/{id}',
                controller='{controller}',
                action='edit'
                )
    map.connect('/admin/{controller}/save/{id}',
                controller='{controller}',
                action='save'
                )
    map.connect('/admin/{controller}/list',
                controller='{controller}',
                action='list'
                )
    map.connect('/admin/{controller}/approve_confirm/{id}',
                controller='{controller}',
                action='approve_confirm'
                )
    map.connect('/admin/{controller}/approve/{id}',
                controller='{controller}',
                action='approve'
                )
    map.connect('/admin/{controller}/disapprove_confirm/{id}',
                controller='{controller}',
                action='disapprove_confirm'
                )
    map.connect('/admin/{controller}/disapprove/{id}',
                controller='{controller}',
                action='disapprove'
                )
    map.connect('/admin/{controller}/delete_confirm/{id}',
                controller='{controller}',
                action='delete_confirm'
                )
    map.connect('/admin/{controller}/delete/{id}',
                controller='{controller}',
                action='delete'
                )  
    
    map.connect('/feeds/', 
                controller='feed', 
                action='redirect_wp_feeds')
    
    map.connect('/feeds/blog', 
                controller='feed', 
                action='posts_feed')
    
    map.connect('/feeds/blog/sitemap', 
                controller='feed', 
                action='posts_feed_sitemap')
    
    map.connect('/feeds/pages/sitemap', 
                controller='feed', 
                action='pages_feed_sitemap')
    
    map.connect('/feeds/comments', 
                controller='feed', 
                action='comments_feed')
    
    map.connect('/feeds/comments/{post_id}',
                controller='feed',
                action='post_comment_feed',
                requirements = dict(post_id='\d+')
    )

    map.connect('/feeds/tag/{slug}',
                controller='feed',
                action='tag_feed',
                requirements = dict(slug='[-\w]+')
    )
    
    # 
    map.connect('/post/{post_id}/{controller}/{action}',
                requirements = dict(post_id='\d+')
    ) 
    
    map.connect('/post/{post_id}/{controller}/{action}/{id}',
                requirements = dict(post_id='\d+', id='\d+')
    )
    
    
    
    map.connect('/blog/{year}/{month}/{slug}', 
                controller='post', 
                action='view', 
                requirements = {'year' : '\d{2,4}', 
                                'month' : '\d{1,2}', 
                                'slug' : '[-\w]+'})
    
    
    
    map.connect('/blog/{year}/{month}', 
                controller='post', 
                action='archive', 
                requirements = {'year' : '\d{2,4}', 
                                'month' : '\d{1,2}'})
    
    map.connect('/blog/{year}', 
                controller='post', 
                action='archive', 
                requirements = {'year' : '\d{2,4}'})
    
    
    
    map.connect('/category/{slug}', 
                controller='tag', 
                action='category', 
                requirements = {'slug' : '[-\w]+'})
    map.connect('/tag/{action}', 
                controller='tag', 
                requirements = {'action' : 'cloud|new|create|edit|save|list|delete'})
    map.connect('/tag/{slug}', 
                controller='tag', 
                action='archive', 
                requirements = {'slug' : '[-\w]+'})
    
    
    map.connect('/{slug}', 
                controller='page', 
                action='view', 
                requirements = {'slug' : '[-\w]+'})
    map.redirect('/{slug}/', '/{slug}', _redirect_code='301 Moved Permanently')    

    map.connect('/{controller}/{action}')
    map.connect('/{controller}/{action}/{id}')

    return map
