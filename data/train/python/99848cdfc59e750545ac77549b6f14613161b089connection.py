import os
from zope import component
import grokcore.component as grok
from collective.zamqp.connection import BrokerConnection
from affinitic.pwmanager.interfaces import IPasswordManager


class AMQPConnection(BrokerConnection):
    grok.name('rabbit')

    @property
    def username(self):
        return component.getUtility(IPasswordManager, name='rabbit').username

    @property
    def password(self):
        return component.getUtility(IPasswordManager, name='rabbit').password

    @property
    def hostname(self):
        return os.environ.get('AMQP_BROKER', 'localhost')
