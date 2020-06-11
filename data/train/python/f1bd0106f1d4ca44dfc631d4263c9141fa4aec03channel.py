import struct

from google.protobuf.service import RpcChannel
from google.protobuf.message import DecodeError
from gevent.hub import get_hub
from gevent.pool import Pool
from gevent.event import AsyncResult
from gevent.queue import Queue
from gevent.greenlet import Greenlet
from gevent import socket
from gevent import core
from gevent import sleep

from controller_pb2 import ControllerProto

from controller import Controller


class Channel(RpcChannel):

    def __init__(self, loop=None):
        self._header = "!I"
        self._loop = loop or get_hub().loop
        self._services = {}
        self._pending_request = {}
        self._transmit_id = 0
        self._send_queue = {}
        self._default_sock = None
        self._greenlet_accept = {}

    def set_default_sock(self, sock):
        if self._default_sock is not None:
            self._default_sock.close()
        self._default_sock = sock

    def append_service(self, service):
        self._services[service.DESCRIPTOR.full_name] = service

    def CallMethod(self, method, controller, request, response_class, done):
        if not isinstance(controller, Controller):
            raise Exception("controller should has type Controller")

        controller.response_class = response_class
        controller.proto.full_service_name = method.containing_service.full_name
        controller.proto.method_name = method.name

        if controller.sock is None:
            controller.sock = self._default_sock

        if controller.proto.notify:
            return self.send_notify(controller, request)
        else:
            return self.send_request(controller, request)

    def send_request(self, controller, request):
        if not self._send_queue.has_key(controller.sock):
            controller.SetFailed("did not connect")
            return None

        self._transmit_id += 1
        controller.async_result = AsyncResult()
        controller.proto.transmit_id = self._transmit_id
        self._pending_request[self._transmit_id] = controller

        controller.proto.stub = True
        controller.proto.message = request.SerializeToString()
        self._send_queue[controller.sock].put(controller)

        return controller.async_result.get()

    def send_notify(self, controller, request):
        controller.proto.stub = True
        controller.proto.message = request.SerializeToString()
        self._send_queue[controller.sock].put(controller)
        return None

    def send_response(self, controller, response):
        controller.proto.stub = False
        if not controller.Failed:
            controller.proto.message = response.SerializeToString()
        self._send_queue[controller.sock].put(controller)

    def connect(self, host, port, as_default=False):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
        while True:
            try:
                result = sock.connect((host, port))
            except socket.error as err:
                raise
            else:
                break
        self.new_connection(sock)
        if as_default:
            self.set_default_sock(sock)
        return sock

    def listen(self, host, port, backlog=1):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind((host, port))
        sock.listen(backlog)
        greenlet_accept = Greenlet.spawn(self._do_accept, sock)
        self._greenlet_accept[sock] = greenlet_accept

    def new_connection(self, sock):
        greenlet_recv = Greenlet.spawn(self._handle, sock)
        greenlet_send = Greenlet.spawn(self._write, sock)

        # closure
        def close(gr):
            greenlet_recv.kill()
            greenlet_send.kill()
            if not self._send_queue.has_key(sock):
                return
            sock.close()
            del self._send_queue[sock]

        greenlet_recv.link(close)
        greenlet_send.link(close)
        self._send_queue[sock] = Queue()

    def _do_accept(self, sock):
        while True:
            try:
                client_socket, address = sock.accept()
                self.new_connection(client_socket)
            except socket.error as err:
                if err.args[0] != socket.EWOULDBLOCK:
                    raise

    def _recv_n(self, sock, length):
        data = ""
        try:
            while len(data) < length:
                buf = sock.recv(length - len(data))
                if len(buf) == 0:
                    return None
                data += buf
        except socket.error as e:
            return None
        assert(len(data) == length)
        return data

    def _handle(self, sock):
        while True:
            header_length = struct.calcsize(self._header)
            header_buffer = self._recv_n(sock, header_length)
            if header_buffer is None:
                break

            controller_length, = struct.unpack(self._header, header_buffer)
            controller_buffer = self._recv_n(sock, controller_length)
            if controller_buffer is None:
                break

            controller = Controller()
            controller.sock = sock

            try:
                controller.proto.ParseFromString(controller_buffer)
            except DecodeError:
                continue

            if not controller.proto.stub:
                self._handle_response(controller)
            elif controller.proto.notify:
                self._handle_notify(controller)
            else:
                self._handle_request(controller)

    def _handle_request(self, controller):
        service = self._services.get(controller.proto.full_service_name, None)
        if service is None:
            controller.SetFailed("service not exist")
            self.send_response(controller, None)
            return

        method = service.DESCRIPTOR.FindMethodByName(controller.proto.method_name)
        if method is None:
            controller.SetFailed("method not exist")
            self.send_response(controller, None)
            return

        request_class = service.GetRequestClass(method)
        request = request_class()
        try:
            request.ParseFromString(controller.proto.message)
        except DecodeError as err:
            return

        response = service.CallMethod(method, controller, request, None)
        self.send_response(controller, response)

    def _handle_notify(self, controller):
        service = self._services.get(controller.proto.full_service_name, None)
        if service is None:
            return

        method = service.DESCRIPTOR.FindMethodByName(controller.proto.method_name)
        if method is None:
            return

        request_class = service.GetRequestClass(method)
        request = request_class()
        try:
            request.ParseFromString(message_buffer)
        except DecodeError as err:
            return

        service.CallMethod(method, controller, request, None)

    def _handle_response(self, controller_):
        controller = self._pending_request.get(controller_.proto.transmit_id, None)
        if controller is None:
            return

        controller.proto = controller_.proto
        if controller.Failed():
            controller.async_result.set(None)
            return

        response = controller.response_class()
        try:
            response.ParseFromString(controller_.proto.message)
        except DecodeError as err:
            return

        del self._pending_request[controller.proto.transmit_id]
        controller.async_result.set(response)

    def _write(self, sock):
        for controller in self._send_queue[sock]:
            if controller is None:
                break
            controller_buffer = controller.proto.SerializeToString()
            header_buffer = struct.pack(self._header, len(controller_buffer))

            sock.sendall(header_buffer)
            sock.sendall(controller_buffer)
