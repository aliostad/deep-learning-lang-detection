from mamayo.application import MamayoDispatchResource
from mamayo.errors import NoSuchApplicationError

import mock

class FakeExplorer(object):
    def __init__(self, application_map):
        self.application_map = application_map

    def application_from_segments(self, segments):
        app = self.application_map.get(tuple(segments))
        if app is None:
            raise NoSuchApplicationError()
        return app

def test_root_as_application():
    "The document root is a possible place for a mamayo app."
    app = mock.Mock()
    explorer = FakeExplorer({(): app})
    dispatch = MamayoDispatchResource(explorer)

    request = mock.Mock(prepath=[])
    assert dispatch.getChildWithDefault('', request) is app.as_resource()
    assert dispatch.getChildWithDefault('something', request) is app.as_resource()
    dispatch.render(request)
    app.as_resource().render.assert_called_once_with(request)

def test_basic_application():
    "A mamayo app can be one directory in the document root."
    app = mock.Mock()
    explorer = FakeExplorer({('foo',): app})
    dispatch = MamayoDispatchResource(explorer)

    request = mock.Mock(prepath=[])
    assert dispatch.getChildWithDefault('', request) is dispatch
    assert dispatch.getChildWithDefault('something', request) is dispatch
    dispatch.render(request)
    assert not app.as_resource().render.called

    request = mock.Mock(prepath=['foo'])
    assert dispatch.getChildWithDefault('something', request) is app.as_resource()
    dispatch.render(request)
    app.as_resource().render.assert_called_once_with(request)

def test_nested_application():
    "A mamayo app can be one directory nested deeply in the document root."
    app = mock.Mock()
    explorer = FakeExplorer({('spam', 'eggs', 'app'): app})
    dispatch = MamayoDispatchResource(explorer)

    for bogus_prepath in [['spam'], ['spam', 'eggs'], ['eggs']]:
        request = mock.Mock(prepath=bogus_prepath)
        assert dispatch.getChildWithDefault('', request) is dispatch
        assert dispatch.getChildWithDefault('something', request) is dispatch
        dispatch.render(request)
        assert not app.as_resource().render.called

    request = mock.Mock(prepath=['spam', 'eggs', 'app'])
    assert dispatch.getChildWithDefault('', request) is app.as_resource()
    assert dispatch.getChildWithDefault('something', request) is app.as_resource()
    dispatch.render(request)
    app.as_resource().render.assert_called_once_with(request)
