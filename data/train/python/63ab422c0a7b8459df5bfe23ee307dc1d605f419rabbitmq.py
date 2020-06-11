import uuid
import traceback

from twisted.internet import defer, reactor
from twisted.internet.protocol import ClientCreator
from twisted.python import log
from txamqp.content import Content
from txamqp.client import TwistedDelegate
from txamqp.protocol import AMQClient
import txamqp.spec
from txamqp.queue import Closed

import xo_server.common.error as error




class BaseBrokerError(Exception):
    pass

class BrokerError(BaseBrokerError):
    def __init__(self, err_id, err_msg, f_name=None, exchange=None):
        self.err_id = err_id
        self.err_msg = err_msg
        self.f_name = f_name
        self.exchange = exchange

    def __repr__(self):
        msg = '<err_id={}, err_msg={}, f_name={}, exchange={}>'.format(
            self.err_id, self.err_msg, self.f_name, self.exchange
        )
        return msg

    def __str__(self):
        return self.__repr__()

class BrokerTimeoutError(BaseBrokerError):
    pass


class RabbitmqBroker(object):
    def __init__(self, service, config, exchange_name, queue_name,
                 handlers_map=None):
        self.broker_callback_map = {}
        self.config = config
        self.service = service
        self.broker = None
        self.broker_conn = None
        self.callback_queue = None
        self.callback_queue_name = None
        self.timeout = 10
        self.fanout_exchange_name = exchange_name + "_fanout"
        self.direct_exchange_name = exchange_name
        self.queue_name = queue_name + ":{}".format(self.service.service_id)
        self.direct_routing_key = self.queue_name
        self.handlers_map = handlers_map



    @defer.inlineCallbacks
    def connect_broker(self):
        delegate = TwistedDelegate()
        spec = txamqp.spec.load(self.config["rabbitmq"]["spec"])

        broker_client = ClientCreator(reactor, AMQClient, delegate=delegate, 
                                      vhost=self.config["rabbitmq"]["vhost"], 
                                      spec=spec)
        broker_conn = yield broker_client.connectTCP(self.config["rabbitmq"]["host"],
                                                     self.config["rabbitmq"]["port"])

        log.msg("Connected to broker.")
        yield broker_conn.authenticate(self.config["rabbitmq"]["user"],
                                       self.config["rabbitmq"]["password"])

        log.msg("Broker authenticated. Ready to send messages")
        chan = yield broker_conn.channel(1)
        yield chan.channel_open()

        self.broker = chan
        self.broker_conn = broker_conn


        yield self.broker.queue_declare(queue=self.queue_name)
        yield self.broker.exchange_declare(exchange=self.fanout_exchange_name, type="fanout", durable=True,
                                           auto_delete=False)
        yield self.broker.exchange_declare(exchange=self.direct_exchange_name, type="direct", durable=True,
                                           auto_delete=False)
        yield self.broker.queue_bind(queue=self.queue_name, exchange=self.direct_exchange_name,
                                     routing_key=self.direct_routing_key)
        yield self.broker.queue_bind(queue=self.queue_name, exchange=self.fanout_exchange_name,
                                     routing_key='')
        yield self.broker.basic_consume(queue=self.queue_name, no_ack=True, consumer_tag=self.queue_name)

        queue = yield self.broker_conn.queue(self.queue_name)
        self.do_queue_tasks(queue)



        result = yield self.broker.queue_declare(exclusive=True)
        self.callback_queue_name = result.queue
        yield self.broker.basic_consume(queue=self.callback_queue_name, no_ack=True,
                                        consumer_tag="callback_queue")
        self.callback_queue = yield self.broker_conn.queue("callback_queue")
        self.do_broker_callback_tasks(self.callback_queue)



    @defer.inlineCallbacks
    def do_callback(self, res, msg):
        log.msg("DEBUG: do_callback: res is %s" % str(res))
        if 'reply to' in msg.content.properties:
            reply_to = msg.content.properties['reply to']
            corr_id = msg.content.properties['correlation id']
            packed_res = self.service.pack(res)
            content_res = Content(packed_res)
            content_res['correlation id'] = corr_id
            yield self.broker.basic_publish(exchange='', content=content_res, 
                                            routing_key=reply_to)


    def create_broker_error(self, error_id, error_message):
        return {"err_id": error_id, "err_msg": error_message}


    @defer.inlineCallbacks
    def do_errback(self, err, msg):
        log.err(err)
        broker_error = self.create_broker_error(error.ERROR_INTERNAL_SERVICE_ERROR,
                                                error.DEFAULT_ERROR_MSG)
        if isinstance(err.value, error.EInternalError):
            broker_error = self.create_broker_error(err.value.error_id, err.value.error_message)

        if 'reply to' in msg.content.properties:
            reply_to = msg.content.properties['reply to']
            corr_id = msg.content.properties['correlation id']
            packed_res = self.service.pack(broker_error)
            content_res = Content(packed_res)
            content_res['correlation id'] = corr_id
            yield self.broker.basic_publish(exchange='', content=content_res, 
                                            routing_key=reply_to)



    @defer.inlineCallbacks
    def do_queue_tasks(self, queue):
        while True:
            try:
                msg = yield queue.get()
                log.msg("DEBUG: do_queue_tasks: got msg %s" % msg)
                unpacked_msg = self.service.unpack(msg.content.body)
                log.msg("DEBUG: do_queue_tasks: unpacked_msg is %s" % unpacked_msg)
                f_name = unpacked_msg["f_name"]
                log.msg("DEBUG: self.handlers_map are {}".format(self.handlers_map))
                if f_name not in self.handlers_map:
                    raise error.EInternalError(error.ERROR_NO_BROKER_METHOD)
                f = self.handlers_map[f_name]
                d = f(unpacked_msg)
                d.addCallback(self.do_callback, msg)
                d.addErrback(self.do_errback, msg)
            except Closed, e_inst:
                log.msg("do_queue_tasks: queue is closed: %s" % str(e_inst))
                break
            except Exception:
                log.err(str(msg))
                formatted_traceback = traceback.format_exc()
                log.err(formatted_traceback)


    def is_broker_error(self, msg):
        if (isinstance(msg, dict) and 
                "err_id" in msg and
                "err_msg" in msg):
            return True
        return False

    @defer.inlineCallbacks
    def do_broker_callback_tasks(self, queue):
        while True:
            try:
                msg = yield queue.get()
                log.msg("DEBUG: do_broker_callback_tasks: got msg %s" % msg)
                unpacked_msg = self.service.unpack(msg.content.body)
                log.msg("DEBUG: do_broker_callback_tasks: unpacked_msg is %s" % str(unpacked_msg))
                corr_id = msg.content.properties['correlation id']
                if corr_id not in self.broker_callback_map:
                    log.err("do_broker_callback_tasks: invalid corr_id %s" % corr_id)
                    continue

                d, f_name, exchange = self.broker_callback_map[corr_id]
                if self.is_broker_error(unpacked_msg):
                    if unpacked_msg["err_id"] == error.ERROR_INTERNAL_SERVICE_ERROR:
                        d.errback(BrokerError(unpacked_msg["err_id"], unpacked_msg["err_msg"],
                                              f_name=f_name, exchange=exchange))
                    else:
                        d.errback(error.EInternalError(unpacked_msg["err_id"]))
                else:
                    d.callback(unpacked_msg)

                del self.broker_callback_map[corr_id]
            except Closed, e_inst:
                log.msg("do_broker_callback_tasks: queue is closed: %s" % str(e_inst))
                break
            except Exception:
                log.error(str(msg))
                formatted_traceback = traceback.format_exc()
                log.error(formatted_traceback)


    def process_timeout_error(self, d, corr_id, msg_info):
        if not d.called:
            if corr_id in self.broker_callback_map:
                del self.broker_callback_map[corr_id]
                log.err("Broker timeout error occured. msg_info is %s" % str(msg_info))
                d.errback(BrokerTimeoutError())


    @defer.inlineCallbacks
    def send_broker_msg(self, exchange, f_name, msg, routing_key=None, server_id=None):
        assert isinstance(msg, dict), "Msg should be dict"
        NON_PERSISTENT = 1
        msg["f_name"] = f_name
        packed_msg = self.service.pack(msg)


        content_msg = Content(packed_msg)
        content_msg["delivery mode"] = NON_PERSISTENT
        content_msg["reply to"] = self.callback_queue_name
        corr_id = str(uuid.uuid4())
        content_msg["correlation id"] = corr_id
        if routing_key is None:
            routing_key = ''
        elif server_id is not None:
            exchange = exchange + ":%d" % server_id
            
        log.msg("DEBUG: send_broker_msg: exchange is %s, f_name is %s, msg is %s" % (str(exchange),
                                                                                     str(f_name), str(msg)))
        self.broker.basic_publish(exchange=exchange, content=content_msg, 
                                  routing_key=routing_key)

        d = defer.Deferred()
        self.broker_callback_map[corr_id] = (d, f_name, exchange)
        msg_info = {
            "exchange": exchange,
            "routing_key": routing_key,
            "f_name": f_name,
            "msg": msg
        }
        reactor.callLater(self.timeout, self.process_timeout_error, d, corr_id, msg_info)
        res = yield d
        defer.returnValue(res)
        

