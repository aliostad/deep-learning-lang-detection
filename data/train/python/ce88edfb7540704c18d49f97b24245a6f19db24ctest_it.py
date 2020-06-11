from pyramid import testing
from pyramid.config import Configurator
from rebecca.repository import repository_config, repository_factory_config
from rebecca.repository import get_repository, create_repository


def _makeApp():
    conf = Configurator()
    conf.include('rebecca.repository')
    conf.scan(".")
    conf.commit()
    request = testing.DummyResource(registry=conf.registry)
    return request


def test_repository():

    request = _makeApp()

    result = get_repository(request, "testing")

    assert isinstance(result, TestingRepository)
    assert result.value == 9999


def test_repository_factory():

    request = _makeApp()

    result = create_repository(request, "testing1", args=(8888,))

    assert isinstance(result, TestingRepository)
    assert result.value == 8888

def test_repository_factory_with_passed_args():

    request = _makeApp()

    result = create_repository(request, "testing2")

    assert isinstance(result, TestingRepository)
    assert result.value == 8282


@repository_config(name="testing", args=(9999,))
@repository_factory_config(name="testing1")
@repository_factory_config(name="testing2", args=(8282,))
class TestingRepository(object):
    """ testing
    """

    def __init__(self, value):
        self.value = value