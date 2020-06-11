from zope.app.component import hooks
from plone.dexterity.utils import createContentInContainer


def addMediaRepository(context):
    def isThisProfile(context):
        return context.readDataFile(
            'plone.app.mediarepository.add_repository.txt')

    if not isThisProfile(context):
        return

    site = hooks.getSite()
    try:
        repo = site['media-repository']
    except KeyError:
        createContentInContainer(site, 'media_repository',
                                 id='media-repository',
                                 title='Media Repository')
