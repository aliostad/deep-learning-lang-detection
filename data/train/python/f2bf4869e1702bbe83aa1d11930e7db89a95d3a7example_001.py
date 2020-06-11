import sys
sys.path.extend(("../../redfoot-core", "../../redfoot-components"))

from redfoot.rdf.store.autosave import AutoSave
from redfoot.rdf.store.storeio import LoadSave
from redfoot.rdf.store.triple import TripleStore

class AutoSaveStoreIO(AutoSave, LoadSave, TripleStore, object):
    def __init__(self):
        super(AutoSaveStoreIO, self).__init__()

from redfoot.rdf.objects import resource, literal
from redfoot.rdf.const import LABEL, TYPE

store = AutoSaveStoreIO() 
store.add(resource("http://eikeon.com/"), LABEL, 
          literal("Daniel 'eikeon' Krech")) 

def print_triple(s, p, o): 
    print s, p, o 

store.visit(print_triple, 
            (resource("http://eikeon.com/"), None, None)) 

store.save('test.rdf')
