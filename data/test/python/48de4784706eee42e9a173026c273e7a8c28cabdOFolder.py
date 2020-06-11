'''OFolder, a folder with explicit control over the order of elements.'''

# Zope 2.12 compatibility
try:
  # new Zope 2.12 places
  from App.class_init import InitializeClass
  from App.special_dtml import DTMLFile
except ImportError:
  # try the old place
  from Globals import InitializeClass, DTMLFile
from AccessControl import ClassSecurityInfo
from AccessControl.Permissions import manage_properties
from OFS.OrderedFolder import OrderedFolder



class OFolder(OrderedFolder):
  '''OFolder behaves like 'OrderedFolder' but provides an additional 'manage_reorder' which allows to directly specify the element order.'''
  meta_type= 'OFolder'

  security= ClassSecurityInfo()

  security.declareProtected(manage_properties,
                            'manage_reorder',
                            )

  def manage_reorder(self, order, REQUEST=None, cmp= lambda x,y: cmp(x.order,y.order)):
    '''reorder the folders children according to *order*.'''
    order.sort(cmp)
    d= _dictify(self._objects); l= []
    for x in order: l.append(d[x.id])
    self._objects= tuple(l)
    if REQUEST is not None:
      return self.manage_main(self,REQUEST,
                              manage_tabs_message='reordered')

  manage_main= DTMLFile('dtml/main', globals())

InitializeClass(OFolder)


manage_addOFolderForm= DTMLFile('dtml/ofolderAdd',globals())
def manage_addOFolder(self,id, title='', REQUEST=None):
  '''add an OFolder.'''
  ob= OFolder()
  ob.id= id; ob.title= title
  self._setObject(id,ob)

  if REQUEST is not None:
    du= getattr(self,'DestinationURL',self.absolute_url)
    du= du()
    REQUEST.RESPONSE.redirect('%s/manage_main?manage_tabs_message=OFolder+created&update_menu:int=1' % du)
    

def _dictify(t):
  d= {}
  for r in t: d[r['id']]= r
  return d
