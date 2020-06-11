from java.lang import Class
from org.gumtree.util.eclipse import E4Utils
from org.gumtree.util.eclipse import FilterBuilder
from org.osgi.service.event import EventHandler

class AbstractEventHandler(EventHandler):

    def __init__(self, topic, filterKey=None, filterValue=None):
        self.topic = topic
        self.activated = False
        self.eventBroker = None
        self.filter = None
        if (not filterKey == None) and (not filterValue == None):
             self.filter = FilterBuilder(filterKey, filterValue).get()
    
    def activate(self):
        if not self.activated:
            self.activated = True
            self. getEventBroker().subscribe(self.topic, self.filter, self, True)
        return self
    
    def deactivate(self):
        if self.activated:
            self.activated = False
            self.getEventBroker().unsubscribe(self);
        return self

    def getEventBroker(self):
        if self.eventBroker == None:
            self.eventBroker = E4Utils.getEclipseContext().get(Class.forName('org.eclipse.e4.core.services.events.IEventBroker'))
        return self.eventBroker
    
    def setEventBroker(self, eventBroker):
        self.eventBroker = eventBroker
