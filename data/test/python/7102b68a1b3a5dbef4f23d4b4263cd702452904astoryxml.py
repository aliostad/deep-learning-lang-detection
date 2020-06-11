""" storyxml.py
Contains a "broker" class that makes it easy to access data in the story XML files uploaded by the Flash applet;
this class is separated from views_flash.py to improve readability of the code and to avoid introducing "non-django view"
functions/classes into that module (separation of concerns, thus). 
"""

from ourstories_django.settings import RED5_UPLOAD_PATH


class Broker(object):
    """ (Very) simple read-only xml broker, allowing quick 'n easy access to the DOM structure """
    
    def __init__(self, xmlNode):
        """ Constructor; don't use this. Use the static getInstance() method to create a new broker
        """
        self._xmlNode = xmlNode
    
    def node(self):
        """ Returns the underlying DOM node of this broker instance """
        return self._xmlNode
    
    def text(self):
        """ Returns any text contained in the direct children of this node """
        rc = ''
        for node in self._xmlNode.childNodes:
            if node.nodeType == node.TEXT_NODE:
                rc = rc + node.data
        return rc
    
    def __getattr__(self, name):
        #TODO: handle nodelists properly (but we don't need it right now)
        tagList = self._xmlNode.getElementsByTagName(name)
        if len(tagList) > 0:
            tag = tagList[0]
            if tag.nodeType == tag.ELEMENT_NODE:
                return Broker(tagList[0])
            else:
                return tag.dat
        else:
            raise AttributeError, "object has no attribute '%s'" % name

class StoryXml(object):
    """ Represents a story XML document uploaded by the OurStories Flash applet """

    def __init__(self, xmlDoc):
        """ Constructor
        @param xmlDoc: The XML document of the story
        @type xmlDoc: xml.dom.minidom.Document
        """
        # Private fields
        self._xmlBroker = Broker(xmlDoc)
        self._categories = None
        # Public fields
        self.title = self._xmlBroker.title.text()
        self.summary = self._xmlBroker.summary.text()
        self.language = self._xmlBroker.language.text()
        self.city = self._xmlBroker.city.text()
        self.country = self._xmlBroker.country.text()
        self.duration = int(self._xmlBroker.recording.duration.text())
        
        self.imageFilename = self._xmlBroker.image.text()
        self.audioFilename = RED5_UPLOAD_PATH + self._xmlBroker.recording.file.text()
        
        self.contributorName = self._xmlBroker.name.text()
        self.contributorEmail = self._xmlBroker.email.text()
        self.contributorAge = int(self._xmlBroker.age.text())
        self.contributorGender = self._xmlBroker.gender.text()[0] # use only the first character, resulting in either M or F
  
    @property
    def categories(self):
        """ A list of category names that the story is tagged with (list of strings) """
        # Lazily initialize this field
        if self._categories == None:
            self._categories = []
            # Certain catgories are hard-coded as element tags by the XML spec in use by the flash applet (ugh).
            categoriesElement = self._xmlBroker.categories.node()
            for node in categoriesElement.childNodes:
                if (node.nodeType != node.TEXT_NODE):
                    if (node.tagName != 'othercategory'):
                        # hard-coded category; check if it is set
                        if (node.firstChild.data.lower() == 'true'):
                            self._categories.append(node.tagName)
                    else:
                        # "othercategory" elements contains comma-separated list of misc categories
                        if (node.firstChild != None):
                            categories = node.firstChild.data.split(',')
                            for categoryName in categories:
                                if (len(categoryName.trim()) > 0):
                                    self._categories.append(categoryName.trim())
        return self._categories

