import datetime
from datetime import datetime
import hashlib
import uuid
from mongokit import Document
from app.DAO import mongo, configParser

__author__ = 'Luka Strizic'


class Dose:
    def __init__(self, document):
        assert(isinstance(document, DoseDocument))
        self.document = document

    def __getitem__(self, item):
        ret = None
        try:
            ret = self.document[str(item)]
        except:
            pass
        return ret

    def save(self):
        self.document.save()

    def setInstitutionID(self, id, save=False):
        self.document['institutionID'] = str(id)
        if(save): self.save()
        return

    def setAB0(self, ab0, save=False):
        self.document['AB0'] = str(ab0)
        if(save): self.save()
        return

    def setRh(self, rh, save=False):
        self.document['RH'] = str(rh)
        if(save): self.save()
        return

    def setAvailable(self, save = False):
        self.document['status'] = 'available'
        if(save): self.save()
        return

    def setUnhealthy(self, save = False):
        self.document['status'] = 'unhealthy'
        if(save): self.save()
        return

    def setUnavailable(self, save = False):
        self.document['status'] = 'unavailable'
        if(save): self.save()
        return

def get_by_id(id):
    doc = mongo.DoseDocument.find_one({'id':id})
    if (doc):
        return Dose(doc)
    return None

def uuidStr():
    return str(uuid.uuid4())

@mongo.register
class DoseDocument(Document):
    __database__ = configParser.get("Mongo","DBname")
    __collection__ = 'doses'

    use_schemaless = True
    use_dot_notation = True

    structure = {
        'id' : basestring,
        'institutionID' : basestring,
        'AB0' : basestring,
        'RH' : basestring,
        'status' : basestring,
        'dateCreated' : datetime,
        'donationId' :basestring
    }

    default_values = {
        'id' : uuidStr,
        'dateCreated' : datetime.utcnow,
        'status' : 'available'
    }
