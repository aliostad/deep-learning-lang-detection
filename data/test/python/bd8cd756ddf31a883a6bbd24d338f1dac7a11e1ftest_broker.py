from mock import call, Mock, patch
from nose.tools import assert_raises, eq_, ok_
from nose.plugins.skip import SkipTest

from beehive.core import *


empty_frame = ''


def test_worker_idle():
    service = Broker.Service()
    worker = Broker.Worker('address', service)

    eq_(worker.idle, False)
    eq_(service.idle_workers, [])

    # When worker.idle is set to True,
    # the worker adds itself to its service's queue
    worker.idle = True
    eq_(service.idle_workers, [worker])

    # This looks like a funny thing to test, but since Worker.idle is a property
    # I want to make sure it returns the proper value.
    eq_(worker.idle, True)

    # When worker.idle is set to False,
    # the worker removes itself from its service's queue
    worker.idle = False
    eq_(service.idle_workers, [])
    eq_(worker.idle, False)


def test_service():
    s = Broker.Service()
    listener = Mock()

    s.on_work(listener)

    # The service starts out with no work to do.
    eq_(listener.mock_calls, [])

    # Add a worker
    s.add_worker('worker1')
    eq_(s.idle_workers, ['worker1'])

    # Still no work to be done
    eq_(listener.mock_calls, [])

    # Add a request
    s.add_request('reply_address', 'request1')

    # Now there's work to be done
    listener.assert_called_once_with(('reply_address', 'request1'), 'worker1')


def test_broker_add_remove_worker():
    stream = Mock()
    broker = Broker(stream)
    s1 = Broker.Service()

    # Broker tracks workers with a dictionary.
    # Initially it's empty
    eq_(broker.workers, {})

    # Service's worker queue is empty
    eq_(s1.idle_workers, [])

    # Add a worker
    w = Broker.Worker('worker1', s1)
    broker.add_worker(w)

    # Broker tracks the worker
    eq_(broker.workers, {'worker1': w})

    # The broker adds the worker to the service's worker queue
    eq_(s1.idle_workers, [w])

    # Trying to add the same worker twice is an error
    with assert_raises(DuplicateWorker):
        broker.add_worker(w)

    broker.remove_worker(w)

    eq_(broker.workers, {})
    eq_(s1.idle_workers, [])

    with assert_raises(UnknownWorker):
        broker.remove_worker(w)
    # TODO sends worker disconnect signal?


def test_register_unregister_worker():
    stream = Mock()
    broker = Broker(stream)

    worker_address = 'worker1'
    service_name = 'test_service'

    # Send a message to the broker telling it to register worker1 for test_service
    msg = [worker_address, empty_frame, opcodes.REQUEST,
           'beehive.management.register_worker', service_name]

    broker.message(msg)

    # Check that the broker is now tracking the worker and the service
    eq_(len(broker.workers), 1)

    eq_(broker.services.keys(), [service_name])
    eq_(broker.workers.keys(), [worker_address])

    # Get the Worker and Service objects from the broker
    worker = broker.workers[worker_address]
    service = broker.services[service_name]

    # Check that the worker is in the service's queue
    eq_(service.idle_workers, [worker])
    eq_(worker.service, service)
    eq_(worker.idle, True)

    # Now send a message to the broker telling it to unregister the worker
    msg = [worker_address, empty_frame, opcodes.REQUEST,
           'beehive.management.unregister_worker', service_name]

    broker.message(msg)
    eq_(broker.workers, {})
    # The service stays registered, even though it doesn't have any workers
    eq_(broker.services.keys(), [service_name])
    eq_(service.idle_workers, [])

    with assert_raises(UnknownWorker):
        broker.message(msg)


def test_register_duplicate_worker():
    stream = Mock()
    broker = Broker(stream)

    worker_address = 'worker1'
    service_name = 'test_service'

    # Send a message to the broker telling it to register worker1 for test_service
    msg = [worker_address, empty_frame, opcodes.REQUEST,
           'beehive.management.register_worker', service_name]

    broker.message(msg)

    with assert_raises(DuplicateWorker):
        broker.message(msg)

    # Check that the broker is now tracking the worker and the service
    eq_(len(broker.workers), 1)

    eq_(broker.services.keys(), [service_name])
    eq_(broker.workers.keys(), [worker_address])

    # Get the Worker and Service objects from the broker
    worker = broker.workers[worker_address]
    service = broker.services[service_name]

    # Check that the worker is in the service's queue
    eq_(service.idle_workers, [worker])
    eq_(worker.service, service)
    eq_(worker.idle, True)


def test_broker_stream_send():
    # Set up a broker
    stream = Mock()
    broker = Broker(stream)

    # The broker sends a message...
    broker.send('address', 'message')

    # ...and the message is passed to stream
    stream.send.assert_called_once_with('address', 'message')


# TODO if the broker ever became multithreaded/evented, this model for testing
#      might not work anymore
def test_client_request():
    stream = Mock()
    broker = Broker(stream)

    # Register a worker
    worker_address = 'worker1'
    service_name = 'test_service'

    # Send a message to the broker telling it to register worker1 for test_service
    msg = [worker_address, empty_frame, opcodes.REQUEST,
           'beehive.management.register_worker', service_name]

    broker.message(msg)

    # Make a request of that worker/service from a client
    client_address = 'client1'
    request_body = 'foo'

    msg = [client_address, empty_frame, opcodes.REQUEST, service_name, request_body]
    broker.message(msg)

    # The broker should have sent the request to the worker and changed some state
    # so that the worker is no longer in the service's idle workers
    service = broker.services[service_name]
    worker = broker.workers[worker_address]

    eq_(service.idle_workers, [])
    stream.send.assert_called_once_with(worker_address, (client_address, request_body))

    stream.reset_mock()

    # Simulate the worker's reply
    reply_body = 'reply foo'
    msg = [worker_address, empty_frame, opcodes.REPLY, client_address, reply_body]
    broker.message(msg)

    stream.send.assert_called_once_with(client_address, reply_body)

    # Now the the worker has responded, it should be made available for more work
    # i.e. be in the service's idle_workers queue
    eq_(service.idle_workers, [worker])


def test_worker_reply_processes_next_request():
    stream = Mock()
    broker = Broker(stream)

    # Queue up two requests
    client_address = 'client1'
    worker_address = 'worker1'
    request_1_body = 'request 1'
    request_2_body = 'request 2'
    reply_1_body = 'reply 1'
    service_name = 'test_service'

    header = [client_address, empty_frame, opcodes.REQUEST, service_name]
    broker.message(header + [request_1_body])
    broker.message(header + [request_2_body])

    # Add a worker. The first request is immediately sent to the worker.
    msg = [worker_address, empty_frame, opcodes.REQUEST,
           'beehive.management.register_worker', service_name]
    broker.message(msg)

    stream.send.assert_called_once_with(worker_address, (client_address, request_1_body))

    stream.reset_mock()

    # Simulate the worker's reply.
    msg = [worker_address, empty_frame, opcodes.REPLY, client_address, reply_1_body]
    broker.message(msg)

    # The reply will be forwarded to the client,
    # and the second request will be sent to the worker.
    eq_(stream.send.mock_calls, [call(client_address, reply_1_body),
                              call(worker_address, (client_address, request_2_body))])


def test_worker_registration_processes_queue_request():
    stream = Mock()
    broker = Broker(stream)

    # Queue a request
    client_address = 'client1'
    worker_address = 'worker1'
    request_body = 'request 1'
    service_name = 'test_service'

    header = [client_address, empty_frame, opcodes.REQUEST, service_name]

    broker.message(header + [request_body])

    # Add a worker. The worker should immediately process the first request.
    msg = [worker_address, empty_frame, opcodes.REQUEST,
           'beehive.management.register_worker', service_name]

    broker.message(msg)

    # Assert that the client's request was sent to the worker
    stream.send.assert_called_once_with(worker_address, (client_address, request_body))


def test_service_request_queue():
    stream = Mock()
    broker = Broker(stream)

    # Queue a request
    client_address = 'client1'
    request_body = 'request 1'
    service_name = 'test_service'

    header = [client_address, empty_frame, opcodes.REQUEST, service_name]

    broker.message(header + [request_body])

    # When a request is sent for a service that doesn't have any workers,
    # that request is queued.

    service = broker.services[service_name]
    eq_(service.requests, [('client1', 'request 1')])

    # TODO these requests should be dropped after some interval


def test_register_reserved_name():
    stream = Mock()
    broker = Broker(stream, internal_prefix='some_prefix')

    worker_address = 'worker1'
    service_name = 'some_prefix.test_service'

    # Send a message to the broker telling it to register worker1 for test_service
    msg = [worker_address, empty_frame, opcodes.REQUEST,
           'some_prefix.management.register_worker', service_name]

    with assert_raises(ReservedNameError):
        broker.message(msg)

    # TODO this error should be returned to the worker


def test_register_empty_service_name():
    stream = Mock()
    broker = Broker(stream)

    worker_address = 'worker1'
    service_name = ''

    # Send a message to the broker telling it to register worker1 for test_service
    msg = [worker_address, empty_frame, opcodes.REQUEST,
           'beehive.management.register_worker', service_name]

    with assert_raises(InvalidServiceName):
        broker.message(msg)


def test_invalid_command():
    stream = Mock()
    broker = Broker(stream)
    
    msg = ['address', empty_frame, 'invalid opcode']
    with assert_raises(InvalidCommand):
        broker.message(msg)
    assert False
