import cherrypy

def setRoutes(root):

    cherrypy.checker.check_static_paths = None 

    d = cherrypy.dispatch.RoutesDispatcher()
    
    m = d.mapper
    m.explicit = True
    m.minimization = False
    
    # new project
    d.connect('newProject-1',   '/new/:lang', controller=root, action='newProject')
    d.connect('newProject-2',   '/new', controller=root, action='newProject')
    
    # pages accessible only through Ajax
    # file management
    d.connect('deleteFile',     '/deleteFile', controller=root, action='deleteFile')
    d.connect('addFile',        '/addFile', controller=root, action='addFile')
    # tickets management and manipulation
    d.connect('saveTicket',     '/saveTicket', controller=root, action='saveTicket')
    d.connect('deleteTicket',   '/deleteTicket', controller=root, action='deleteTicket')
    d.connect('editTicket',     '/editTicket',   controller=root, action='editTicket')
    d.connect('saveComment',    '/saveComment', controller=root, action='saveComment')
    d.connect('getTicketsList', '/getTicketsList', controller=root, action='getTicketsList')
    d.connect('getCommentsList','/getCommentsList', controller=root, action='getCommentsList')
    d.connect('setSort',        '/setSort', controller=root, action='setSort')
    d.connect('editTicketForm', '/editTicketForm', controller=root, action='editTicketForm')
    # login
    d.connect('doLogin',        '/doLogin', controller=root, action='doLogin')
    # user management
    d.connect('deleteUser',     '/deleteUser', controller=root, action='deleteUser')
    d.connect('acceptUser',     '/acceptUser', controller=root, action='acceptUser')
    d.connect('updateUserLevel','/updateUserLevel', controller=root, action='updateUserLevel')
    d.connect('sendInvitations','/sendInvitations', controller=root, action='sendInvitations')
    # profile
    d.connect('updateEMail',    '/updateEMail', controller=root, action='updateEMail')
    d.connect('updatePwd',      '/updatePwd', controller=root, action='updatePwd')
    # new project
    d.connect('createProject',   '/createProject', controller=root, action='createProject')
    # register
    d.connect('doRegister',   '/doRegister', controller=root, action='doRegister')
    # lost password
    d.connect('doLostPassword',   '/doLostPassword', controller=root, action='doLostPassword')
    
    # general actions
    d.connect('raiseError',     '/raiseError', controller=root, action='raiseError')
    d.connect('disconnect',     '/:project/disconnect', controller=root, action='disconnect')
    
    # get file
    d.connect('file',          '/:project/file/:id', controller=root, action='files')
    
    
    #####
    d.connect('manageUsers',    '/:project/users', controller=root, action='users')
    d.connect('newTicket',      '/:project/:category/new', controller=root, action='newTicket')
    d.connect('profile',        '/:project/profile', controller=root, action='profile')
    d.connect('search-1',       '/:project/search/:search', controller=root, action='search')
    d.connect('search-2',       '/:project/search', controller=root, action='search')
    d.connect('register',       '/:project/register', controller=root, action='register')
    #####
    d.connect('lostPassword',   '/:project/lostPassword',                   controller=root, action='lostPassword')
    
    #d.connect('logMeIn-1',      '/:project/login/:category/:idTicket',     controller=root, action='logMeIn')
    #d.connect('logMeIn-2',      '/:project/login/:category',              controller=root, action='logMeIn')
    d.connect('logMeIn-3',      '/:project/login',                        controller=root, action='logMeIn')
    # ticket
    d.connect('projects-1',     '/:project/:category/:ticketID',             controller=root, action='projects')
    d.connect('projects-2',     '/:project/:category',                      controller=root, action='projects')
    d.connect('projects-3',     '/:project',                                controller=root, action='projects', category='bug')
    
    d.connect('root',           '/',                                controller=root, action='newProject')
    
    return d