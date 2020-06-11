from jinja2 import Template
from nose.tools import raises
from ketchlip.controllers.base_controller import BaseController
from ketchlip.views.search_view import SearchView

@raises(NotImplementedError)
def test_raises_type_error():
    BaseController().show("")

def test_get_view():
    controller = BaseController()
    controller.name = "search"
    assert isinstance(controller.get_view(), SearchView)

def test_get_template():
    controller = BaseController()
    controller.name = "search"
    assert isinstance(controller.get_template(), Template)
