import pytest

from crust import requests
from crust.api import Api


def test_api_initializes_without_error():
    Api("http://example.com/v1/")


def test_empty_api_initializes_throws_exception():
    with pytest.raises(TypeError):
        Api()


def test_api_accepts_session():
    Api("http://example.com/v1/", session=requests.session())


def test_api_has_url():
    api = Api("http://example.com/v1/")
    assert api.url == "http://example.com/v1/"


def test_api_has_session():
    api = Api("http://example.com/v1/")
    assert api.session
