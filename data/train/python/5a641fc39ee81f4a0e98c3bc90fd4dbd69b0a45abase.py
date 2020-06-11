def get_class( kls ):
    '''Get a class by its name'''
    parts = kls.split('.')
    module = ".".join(parts[:-1])
    m = __import__( module )
    for comp in parts[1:]:
        m = getattr(m, comp)            
    return m

def create_view_from_controller(controller):
    '''Create an instance of a view object for the specified controller'''
    return get_class(get_view_class_name(controller))()

def get_view_class_name(controller):
    '''Generate the view class name from the controller.'''
    return 'views.%(section_name)s.%(view_name)s' % {
        'section_name': ".".join(controller.__class__.__module__.split('.')[1:]), 
        'view_name': controller.__class__.__name__
    }

class Controller(object):
    '''Base Controller class. Always subclass this.'''
    
    def __init__(self):
        self.view = create_view_from_controller(self) # create the view by convention