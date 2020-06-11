from tornado.ioloop import IOLoop
from tornado.web import Application, url
from application_handler import ApplicationHandler
from application_repository import ApplicationRepository


def make_app():
    return Application(get_handlers())


def get_handlers():
    return [
        url(r"/application/?", ApplicationHandler, dict(application_repository=ApplicationRepository())),
        url(r"/application/(.+)", ApplicationHandler, dict(application_repository=ApplicationRepository()))
    ]


def main():
    app = make_app()
    app.listen(8888)
    IOLoop.current().start()


if __name__ == "__main__":
    main()
