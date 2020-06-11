"""Routes configuration

The more specific and detailed routes should be defined first so they
may take precedent over the more generic routes. For more information
refer to the routes manual at http://routes.groovie.org/docs/
"""
from routes import Mapper


def make_map(config):
    """Create, configure and return the routes Mapper"""
    map = Mapper(directory=config['pylons.paths']['controllers'],
                 always_scan=config['debug'])
    
    map.minimization = False
    map.explicit = False
    
    # The ErrorController route (handles 404/500 error pages); it should
    # likely stay at the top, ensuring it can always be resolved
    map.connect('/error/{action}', controller='error')
    map.connect('/error/{action}/{id}', controller='error')

    # CUSTOM ROUTES HERE

    map.connect(None, '/', controller='user_overview', action='index')
    map.connect(None, '/user', controller='user_overview', action='index')
    map.connect(None, '/user/', controller='user_overview', action='index')
    map.connect(None, '/user/overview', controller='user_overview')
    map.connect(None, '/user/overview/', controller='user_overview')
    map.connect(None, '/user/overview/{action}', controller='user_overview', action='index')
    map.connect(None, '/user/vos', controller='user_vos', action='index')
    map.connect(None, '/user/clusters', controller='user_clusters', action='index')
    map.connect(None, '/user/clusters/', controller='user_clusters', action='index')
    map.connect(None, '/user/clusters/{action}', controller='user_clusters', )
    map.connect(None, '/user/clusters/{action}/{id}', controller='user_clusters')
    map.connect(None, '/user/clusters/{action}/{id}/{queue}', controller='user_clusters')
    map.connect(None, '/user/jobs', controller='user_jobs')
    map.connect(None, '/user/jobs/', controller='user_jobs')
    map.connect(None, '/user/jobs/{action}', controller='user_jobs')
    map.connect(None, '/user/jobs/{action}/{status}', controller='user_jobs')
    map.connect(None, '/user/jobdetails/{dn}/{jobid}',controller='user_job_details')
    map.connect(None, '/user/statistics', controller='user_statistics')
    map.connect(None, '/user/statistics/', controller='user_statistics')
    map.connect(None, '/user/statistics/{action}', controller='user_statistics')
    map.connect(None, '/user/tickets', controller='user_tickets')
    map.connect(None, '/user/tickets/', controller='user_tickets')
    map.connect(None, '/user/links', controller='user_links')
    map.connect(None, '/user/links/', controller='user_links')
    
    # site admin
    map.connect(None, '/siteadmin', controller='siteadmin_overview', action='index')
    map.connect(None, '/siteadmin/', controller='siteadmin_overview', action='index')
    map.connect(None, '/siteadmin/overview', controller='siteadmin_overview')
    map.connect(None, '/siteadmin/overview/', controller='siteadmin_overview')
    map.connect(None, '/siteadmin/overview/{action}', controller='siteadmin_overview')
    map.connect(None, '/siteadmin/clusters', controller='siteadmin_clusters', action='index')
    map.connect(None, '/siteadmin/clusters/', controller='siteadmin_clusters', action='index')
    map.connect(None, '/siteadmin/clusters/{action}', controller='siteadmin_clusters', )
    map.connect(None, '/siteadmin/clusters/{action}/{id}', controller='siteadmin_clusters')
    map.connect(None, '/siteadmin/clusters/{action}/{id}/{queue}', controller='siteadmin_clusters')
    map.connect(None, '/siteadmin/jobs', controller='siteadmin_jobs')
    map.connect(None, '/siteadmin/jobs/', controller='siteadmin_jobs')
    map.connect(None, '/siteadmin/jobs/{action}', controller='siteadmin_jobs')
    map.connect(None, '/siteadmin/users', controller='siteadmin_users')
    map.connect(None, '/siteadmin/testjobs', controller='siteadmin_testjobs')
    map.connect(None, '/siteadmin/testjobs/', controller='siteadmin_testjobs')
    map.connect(None, '/siteadmin/testjobs/{action}', controller='siteadmin_testjobs')
    map.connect(None, '/siteadmin/testjobs/{action}/{suit}', controller='siteadmin_testjobs')
    map.connect(None, '/siteadmin/statistics', controller='siteadmin_statistics')
    map.connect(None, '/siteadmin/statistics/', controller='siteadmin_statistics')
    
    # grid admin
    map.connect(None, '/gridadmin',controller='gridadmin_overview')
    map.connect(None, '/gridadmin/',controller='gridadmin_overview')
    map.connect(None, '/gridadmin/overview', controller='gridadmin_overview')
    map.connect(None, '/gridadmin/overview/', controller='gridadmin_overview')
    map.connect(None, '/gridadmin/overview/{action}', controller='gridadmin_overview')
    map.connect(None, '/gridadmin/clusters', controller='gridadmin_clusters')
    map.connect(None, '/gridadmin/clusters/', controller='gridadmin_clusters')
    map.connect(None, '/gridadmin/clusters/{action}', controller='gridadmin_clusters')
    map.connect(None, '/gridadmin/clusters/{action}/{id}', controller='gridadmin_clusters')
    map.connect(None, '/gridadmin/clusters/{action}/{id}/{queue}', controller='gridadmin_clusters')
    map.connect(None, '/gridadmin/sfts', controller='gridadmin_sfts')
    map.connect(None, '/gridadmin/sfts/', controller='gridadmin_sfts')
    map.connect(None, '/gridadmin/sfts/{action}', controller='gridadmin_sfts')
    map.connect(None, '/gridadmin/sfts/{action}/{name}', controller='gridadmin_sfts')
    map.connect(None, '/gridadmin/sfts/{action}/{name}/{cluster_name}', controller='gridadmin_sfts')
    map.connect(None, '/gridadmin/statistics', controller='gridadmin_statistics')
    map.connect(None, '/gridadmin/statistics/', controller='gridadmin_statistics')
    map.connect(None, '/gridadmin/statistics/{action}', controller='gridadmin_statistics')
    map.connect(None, '/gridadmin/statistics/{action}/{ctype}', controller='gridadmin_statistics')
    map.connect(None, '/gridadmin/infosys', controller='gridadmin_infosys')
    map.connect(None, '/gridadmin/infosys/', controller='gridadmin_infosys')
    map.connect(None, '/gridadmin/infosys/{action}', controller='gridadmin_infosys')
    map.connect(None, '/gridadmin/infosys/{action}/{arg}', controller='gridadmin_infosys')
    #map.connect(None, '/gridadmin/plot/{action}/{type}/{name}', controller='gridadmin_plot')

    # administrator interface for GridMonitor
    map.connect(None, '/monadmin',controller='monadmin')
    map.connect(None, '/monadmin/',controller='monadmin')
    map.connect(None, '/monadmin/acl/', controller='monadmin_acl')
    map.connect(None, '/monadmin/acl', controller='monadmin_acl')
    map.connect(None, '/monadmin/acl/{action}', controller='monadmin_acl')
    map.connect(None, '/monadmin/acl/{action}/{id}', controller='monadmin_acl')
    map.connect(None, '/monadmin/sft', controller='monadmin_sft')
    map.connect(None, '/monadmin/sft/', controller='monadmin_sft')
    map.connect(None, '/monadmin/sft/{action}', controller='monadmin_sft')
    map.connect(None, '/monadmin/sft/{action}/{id}', controller='monadmin_sft')
   

    #json interfaces 

    map.connect(None, '/json/cluster/{action}', controller='cluster')
    map.connect(None, '/json/cluster/{action}/{hostname}', controller='cluster')
    map.connect(None, '/json/cluster/{action}/{hostname}/{tag}', controller='cluster')
    map.connect(None, '/json/grid/{action}', controller='grid')
    map.connect(None, '/json/jobs/{action}', controller='jobs')
    map.connect(None, '/json/jobs/{action}/{arg1}', controller='jobs')
    map.connect(None, '/json/jobs/{action}/{arg1}/{arg2}', controller='jobs')
    map.connect(None, '/json/statistics/{action}', controller='statistics')

 
    # help 
    map.connect(None,'/help', controller='help')

    # public part of monitor (non AAI protected) -> can be used as widget in other web-pages
    map.connect(None,'/public', controller='public_summary')
    map.connect(None,'/public/{action}', controller='public_summary')
    map.connect(None,'/public/{action}/{ce}', controller='public_summary')

    return map
