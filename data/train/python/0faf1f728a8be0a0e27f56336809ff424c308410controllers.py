#coding: utf-8
import web

web.config.debug = True
#session = web.session.Session(app, web.session.DiskStore('sessions'), initializer={'user': {}})



class controller:
    def __init__(self):
        #self.user = {'mobile': '13006699866', 'status': 1}
        #session.user =  {'mobile': '13006699866', 'status': 1}
        pass



class user_controller(controller):
    def __init__(self):
        controller.__init__(self)
        pass

class admin_controller(user_controller):
    def __init__(self):
        user_controller.__init__(self)
        pass