import webapp2

import ann_config

from controllers.admin_deliver_controller import AdminIssueDeliverController
from controllers.admin_printer_list_controller import AdminPrinterListController
from controllers.main_controller import AboutController, MainController
from controllers.dashboard_controller import DashboardController
from controllers.printer_add_controller import PrinterAddController
from controllers.printer_delete_controller import PrinterDeleteController
from controllers.printer_test_print_controller import PrinterTestPrintController

app = webapp2.WSGIApplication([
    ('/', MainController),
    ('/about', AboutController),
    ('/admin/printers/list', AdminPrinterListController),
    ('/admin/issue/deliver', AdminIssueDeliverController),
    ('/dashboard', DashboardController),
    ('/printers/add', PrinterAddController),
    ('/printers/delete', PrinterDeleteController),
    ('/printers/test', PrinterTestPrintController),
    (ann_config.oauth_decorator.callback_path, ann_config.oauth_decorator.callback_handler()),
], debug=True)
