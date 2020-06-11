from collective.grok import gs
from platocdp.policy import MessageFactory as _
import os

basedir = os.path.dirname(__file__)

@gs.importstep(
    name=u'platocdp.policy', 
    title=_('platocdp.policy import handler'),
    description=_(''))
def setupVarious(context):
    if context.readDataFile('platocdp.policy.marker.txt') is None:
        return
    portal = context.getSite()

    # swap logo
    custom=portal.portal_skins.custom
    if not 'logo.png' in custom.keys():
        custom.manage_addProduct['OFSP'].manage_addImage(
             id='logo.png', title='', file=open(
                 os.path.join(basedir, 'overrides', 'logo.png')
             )
        )


    # replace with memcache
    portal.manage_delObjects(['RAMCache'])
    portal.manage_addProduct['MemcachedManager'].manage_addMemcachedManager(id='RAMCache')

