## web_controller.py

import os, web
#from controllers import * 
#import controllers.help

class Handler(object):  

    def control(self, args = False):        
        # Set default controller and method name
        controller = 'Home'
        path_file = './'
        method_name = 'index'

        method_args = []        

        if args:
            # cange all arguments into lists
            method_args = args.split('/')
            
            # Get index key 0 from lists as controller name
            controller = method_args[0].title()
                        # remove key 0 and 1 from list, coz it useless right now
            method_args.pop(0)
            
            # Get mothod name from index 0
            if len(method_args)>0 and method_args[0]=='':
                method_args.pop(0)

            if len(method_args) > 0 and method_args[0] != '':
                method_name = method_args[0]
                method_args.pop(0)            
        path_file += controller.lower()

        path_file += '.py'        

        # Does controller file exists?
        # print path_file 
        if not os.path.isfile(path_file):

            return web.notfound()#'No controller '+ controller +' exists.'
        try:           

            # controller_module= __import__("apps.controllers."+controller.lower(),fromlist='*')            
            controller_module=__import__(controller.lower(),fromlist='*')
            #controller_module = __import__(os.path.splitext(bkfile)[0])
            #controller_module = __import__("controllers."+controller.lower(), globals(), locals(), [controller])                                                
            
            controller_instance = getattr(controller_module, controller)()
            # Does method exists?
            if not hasattr(controller_instance, method_name):                            
                return web.notfound()#'No method '+ method_name +' exists in ' + controller +' instance.'
            return getattr(controller_instance, method_name)(url=method_args)

        except Exception, e:
             return e 
            #return "not found controller "+ controller
        #return args


