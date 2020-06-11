#!/usr/bin/env python
"""
This module conains the base class used by other PAC components (agents).

The BaseAgent class implements the IEventBroker interface, and provides an
event bus.
"""

from spark.interfaces import IEventBroker
from spark.event import EventBus
from zope.interface import implements


class BaseAgent(object):
    """
    Base class providing an event bus.

    It has to be subclassed by sepecialized agents.
    """

    implements(IEventBroker)

    def __init__(self):
        self.eventbus = EventBus()

    def get_event_bus(self):
        return self.eventbus
