import pytest
import zmq

from mdbase.client import MajorDomoClient


@pytest.fixture
def broker_url():
    return "tcp://localhost:6666"


class TestMajorDomoClient():
    def test_instantiate(self, broker_url):
        """Test instantiating client"""
        c = MajorDomoClient(broker_url)
        assert c.broker == broker_url
        assert c.verbose is False
        assert isinstance(c.ctx, zmq.Context)
        assert isinstance(c.poller, zmq.Poller)

    def test_verbose(self, broker_url):
        """Test setting of verbose on client"""
        c = MajorDomoClient(broker_url, True)
        assert c.broker == broker_url
        assert c.verbose is True
        assert isinstance(c.ctx, zmq.Context)
        assert isinstance(c.poller, zmq.Poller)
