import web
import controller
import os

render = web.template.render('app/src/view')

urls = (
    '/hello',                               'hello',
    '/route',                               'controller.route.index',
    '/route/(\d+)',                         'controller.route.show',
    '/route/(\d+)/bus',                     'controller.bus.index',
    '/route/(\d+)/bus/(\d+)',               'controller.bus.show',
    '/route/(\d+)/bus/(\d+)/stop',          'controller.stop.index',
    '/route/(\d+)/bus/(\d+)/stop/(\d+)',    'controller.stop.show',
)

app = web.application(urls, globals())

class hello:
    def GET(self):
        return render.hello()

def is_test():
    if 'WEBPY_ENV' in os.environ:
        return os.environ['WEBPY_ENV'] == 'test'

if (not is_test()) and __name__ == "__main__": app.run()

