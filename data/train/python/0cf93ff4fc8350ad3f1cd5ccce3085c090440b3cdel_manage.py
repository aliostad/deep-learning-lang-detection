from App import ApplicationManager, Management
from OFS import ObjectManager, SimpleItem


TOP_CLASSES = (
    Management.Tabs,
    Management.Navigation,
    ObjectManager.ObjectManager,
    SimpleItem.Item,
)

MAINS = (
    'manage',
    'manage_main',
    'manage_menu',
    'manage_top_frame',
    'manage_page_header',
    'manage_page_footer',
    'manage_workspace',
)

OTHERS = (
    'manage_pack',
    'manage_components',
    'manage_propertiesForm',
    'manage_access',
    'manage_UndoForm',
    'manage_interfaces',
    'manage_findForm',
    'manage_owner',
    'manage_search',
)

BLACK_LIST = (
    #thoses ones are used during zope instance start
    'manage_afterAdd',
    'manage_addProduct',
    'manage_upload',

    #use at Plone site creation time (setup handlers)
    'manage_delObjects',
    'manage_properties',
    'manage_editDiffFields',
    'manage_reindexIndex',
    'manage_setTypePolicies',
    'manage_updateProtocolMapping',
    'manage_updateProtocolMapping',
    'manage_activateInterfaces',
    'manage_addPolicy',
    'manage_editProps',
    'manage_setLanguageSettings',
)


DISCOVERED = set()


#remove path of the zmi
from plone.app.theming import zmi


def patch_zmi():
    pass
zmi.patch_zmi = patch_zmi


OPTION = {'label': 'Contents', 'action': 'manage_main'}


def fake_manage(instance):
    """no more"""
    return "no more zmi"


def del_manage_(klass):
    for name in MAINS:
        if hasattr(klass, name):
            setattr(klass, name, fake_manage)
    for name in OTHERS:
        if hasattr(klass, name):
            try:
                delattr(klass, name)
            except AttributeError:
                pass
    if hasattr(klass, 'manage_options'):
        klass.manage_options = (OPTION,)
    members = klass.__dict__.keys()
    for name in members:
        if name.startswith('manage_'):
            if name == 'manage_options':
                continue
            if name in MAINS:
                continue
            if name in OTHERS:
                continue
            if name.endswith('__roles__'):
                continue
            if name in BLACK_LIST:
                continue
            if not hasattr(klass, name):
                continue
            DISCOVERED.add(name)
            try:
                delattr(klass, name)
            except AttributeError:
                print "can t remove %s %s " % (name, klass)


def inheritors(klass):
    subclasses = set()
    work = [klass]
    while work:
        parent = work.pop()
        for child in parent.__subclasses__():
            subclasses.add(child)
            work.append(child)
    return subclasses


def do_patch():
    for top_class in TOP_CLASSES:
        del_manage_(top_class)
        for sub in inheritors(top_class):
            del_manage_(sub)


do_patch()


#fix the path of Plone for ZMI (to add the add plonesite button)
class FakeManageMain(object):

    def read(self):
        return '<!-- Add object widget -->'

    def cook(self):
        pass

ObjectManager.ObjectManager.manage_main = FakeManageMain()
ObjectManager.ObjectManager.manage_FTPlist = fake_manage
