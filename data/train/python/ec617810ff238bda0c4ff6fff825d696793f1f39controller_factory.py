from http_response import HttpResponse
from http_request import HttpRequest
from http_request_parser import HttpRequestParser
from .controller import Controller
from exceptions.no_controller_exception import NoControllerException
import importlib
import re

#FIXME: Łapane są tutaj wszystkie mozliwe wyjątki i automatycznie jest robione z tego 404. To nie zawsze ma sens.
#FIXME: Do zmiany. Należy osobno obsłużyć sytuacji braku kontrolera i np. błędu w jego kodzie itp.


class ControllerFactory:
    @staticmethod
    def create(controller_name: str, http_request: HttpRequest, http_response: HttpResponse,
               http_request_parser: HttpRequestParser) -> Controller:
        try:
            controller_filename = ControllerFactory._controller_name_to_filename(controller_name)
            globals()[controller_name] = importlib.import_module(controller_filename).IndexController
            controller_class = globals()[controller_name]
            controller = controller_class(http_request, http_response, http_request_parser)
        except Exception as e:
            raise NoControllerException()
        return controller

    @staticmethod
    def _controller_name_to_filename(controller_name: str) -> str:
        resp = re.search('(.*)Controller', controller_name)
        filename = resp.group(1).lower()
        return filename + '_controller'

