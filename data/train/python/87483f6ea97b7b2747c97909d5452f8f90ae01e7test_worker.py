import pytest
import zmq

from mdbase import constants
from mdbase.broker import MajorDomoBroker
from mdbase.worker import MajorDomoWorker


@pytest.fixture
def broker_url():
    return "tcp://localhost:6666"

class TestMajorDomoWorker():
    def test_instantiate(self, broker_url):
        """Test instantiating worker model"""
        service_name = b"echo"
        verbose = False
        w = MajorDomoWorker(broker_url, service_name, verbose)
        assert w.broker == broker_url
        assert w.service == service_name
        assert w.verbose == verbose
        assert isinstance(w.ctx, zmq.Context)
        assert isinstance(w.poller, zmq.Poller)

    @pytest.mark.xfail
    #TODO determine how to mock the necessary parts
    def test_send_to_broker_model(self, broker_url):
        """Test send message to broker"""
        b = MajorDomoBroker(False)
        w = MajorDomoWorker(broker_url, b"echo", False)
        w.send_to_broker(constants.W_REQUEST, b.service, [b"test"])

    @pytest.mark.xfail
    #TODO need to test send to broker method first
    def test_reconnect_to_broker_model(self, broker_url):
        """Test reconnecting to broker"""
        b = MajorDomoBroker(False)
        w = MajorDomoWorker(broker_url, b"echo", False)
