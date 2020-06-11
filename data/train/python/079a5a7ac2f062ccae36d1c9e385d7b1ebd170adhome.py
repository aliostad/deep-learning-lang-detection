#!/usr/bin/env python

from MicroMVC import controller

class home(controller.BaseController):
    content_type = 'text/html'

    @controller.action(paths=('/', '/Default.aspx'))
    def index(self, **kwargs):
        return self.render('index')

    @controller.action()
    def about(self, **kwargs):
        return self.render('about')

    @controller.action(paths=('/developers', '/Developer.aspx',))
    def developers(self, **kwargs):
        return self.render('developers')

    @controller.action(paths=('/stats', '/Stats.aspx',))
    def stats(self, **kwargs):
        return self.render('stats')

    @controller.action(paths=('/404',))
    def not_found(self, **kwargs):
        return self.render('notfound')
