import tornado.ioloop
import os

from Controller import *

WEB_SERVER_PORT = 80
settings = {
    "resources_path": os.path.join(os.path.dirname(__file__), "resources"),
    "template_path": os.path.join(os.path.dirname(__file__), "pages"),
    "cookie_secret": "61oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo=",
    "xsrf_cookies": False,
    "debug" : True
}

application = tornado.web.Application([
    (r"/resources/(.*)", tornado.web.StaticFileHandler, dict(path=settings['resources_path'])),
    (r"/forend/(\w*)", ForendDefaultController),
    (r"/forend/myCenter/(\w*)", ForendMyCenterController),
    (r"/forend/roomBooking/(\w*)", ForendRoomBookingController),
    (r"/forend/mealBooking/(\w*)", ForendMealBookingController),
    (r"/backend/(\w*)", BackendDefaultController),
    (r"/backend/customer/(\w*)", BackendCustomerController),
    (r"/backend/room/(\w*)", BackendRoomController),
    (r"/backend/cleanTask/(\w*)", BackendCleanTaskController),
    (r"/backend/employee/(\w*)", BackendEmployeeController),
    (r"/backend/roomBooking/(\w*)", BackendRoomBookingController),
    (r"/backend/mealBooking/(\w*)", BackendMealBookingController),
    (r"/backend/dishCategory/(\w*)", BackendDishCategoryController),
    (r"/backend/roomCategory/(\w*)", BackendRoomCategoryController),
    (r"/upload", FileUploadController)
    ], **settings)

if __name__ == "__main__":
    application.listen(WEB_SERVER_PORT)
    tornado.ioloop.IOLoop.instance().start()


