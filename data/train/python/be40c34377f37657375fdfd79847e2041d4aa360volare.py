#!/usr/bin/env python
#-*- coding:utf-8 -*-

#
# Volare 1.1.x - Agora usa stomp para enviar mensagens para o ActiveMQ
# - Garante que as mensagens são enviadas com persistent=true, para
#   manter o padrão usado pelo Volare Java via JMS.
#

import socket
from event import Event
from stomp import Connection
from stomp.exception import NotConnectedException, ConnectFailedException

class Volare(object):

    # Construtor simplificado, similar ao usado em Java
    # Note que broker deve ser uma url do tipo "stomp://host:port[/]",
    # que será decodificada para isolar o host e a porta usados pelo stomppy
    def __init__(self, user, password, broker):

        self.user = user
        self.password = password

        if not broker:
            raise ValueError(u"A url do broker é obrigatória.")

        if not broker.startswith("stomp://"):
            raise ValueError(u"A url do broker deve usar 'stomp://'.")
         
        # como broker é da forma 'stomp://hostname:porta[/]', pode remover
        # o prefixo, desprezar a '/' opcional no final e separar no ':'

        self.host, dummy, strport = broker[8:].rstrip('/').partition(':')

        if len(self.host) == 0 or not strport.isdigit():
            raise ValueError(u"O host e a porta do broker são obrigatórios.")

        self.port = int(strport)


    def connect(self):
        try:
            self._connection = Connection([(self.host, self.port)], self.user, self.password)
            self._connection.start()
            self._connection.connect(wait=True)
        except ConnectFailedException, err:
            raise OfflineBrokerError("Failed to connect to the broker at stomp://%s:%s/" % (self.host, self.port) )

    def assert_is_connected(self):
        if not hasattr(self, '_connection') or not self._connection or not self._connection.is_connected():
            raise RuntimeError(u"Você precisa estar conectado (método connect) antes de tentar desconectar.")

    def disconnect(self):
        self.assert_is_connected()
        self._connection.disconnect(send_disconnect=False)

    def send(self, event, topic):
        self.assert_is_connected()
        if not isinstance(event, Event):
            raise TypeError("event should be a Event")

        _message = str(event.to_xml())

        self._connection.send(message = _message, destination = "/topic/" + topic,
              headers = {'type':'textMessage', 'persistent':True} )

class OfflineBrokerError(RuntimeError):
    pass

