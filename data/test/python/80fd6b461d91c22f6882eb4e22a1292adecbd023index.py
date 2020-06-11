import webapp2
from controller import CarController, ExpenseController, ExportController


application = webapp2.WSGIApplication([
                                          (r'/', CarController),
                                          (r'/car', CarController),
                                          (r'/car/(\d+)', CarController),
                                          (r'/export', ExportController),
                                          (r'/car/(\d+)/expense', ExpenseController),
                                          (r'/car/(\d+)/expense/(\d+)', ExpenseController),
                                      ], debug=True)

