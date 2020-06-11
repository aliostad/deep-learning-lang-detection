import pytest
import mock
from hamcrest import assert_that, equal_to
from matchmock import called_once_with
from smoke import Broker, Disconnect, StopPropagation


@pytest.fixture
def listener():
    return mock.Mock()


@pytest.fixture
def broker():
    return Broker()


def test_calls_subscribed(broker, listener):
    event = 'test'
    sentinel = object()
    broker.subscribe(event, listener.test_cb)
    broker.publish(event, s=sentinel)

    assert_that(listener.test_cb, called_once_with(s=sentinel))


def test_disconnect(broker, listener):
    event = 'test'
    broker.subscribe(event, listener.test_cb)
    broker.subscribe(event, listener.test2_cb)
    broker.publish(event)

    broker.disconnect(event, listener.test_cb)
    broker.publish(event)

    assert_that(listener.test_cb.call_count, equal_to(1))
    assert_that(listener.test2_cb.call_count, equal_to(2))


def test_disconnect_exc(broker, listener):
    event = 'test'
    listener.spam_cb = mock.Mock(side_effect=Disconnect)

    broker.subscribe(event, listener.spam_cb)
    broker.subscribe(event, listener.spam_cb2)
    broker.publish(event)
    broker.publish(event)

    assert_that(listener.spam_cb.call_count, equal_to(1))
    assert_that(listener.spam_cb2.call_count, equal_to(2))


def test_stop_exc(broker, listener):
    event = 'test'
    listener.spam_cb = mock.Mock(side_effect=StopPropagation)
    broker.subscribe(event, listener.spam_cb)
    broker.subscribe(event, listener.spam_cb2)
    broker.publish(event)

    assert_that(listener.spam_cb.call_count, equal_to(1))
    assert_that(listener.spam_cb2.call_count, equal_to(0))
