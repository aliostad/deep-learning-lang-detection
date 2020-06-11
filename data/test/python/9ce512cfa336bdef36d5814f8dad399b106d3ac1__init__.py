# Copyright (c) 2004 Zope Corporation and Plone Solutions
# ZPL 2.1 license

def initialize(context):
    from Products.ExtendedPathIndex.ExtendedPathIndex import ExtendedPathIndex
    from Products.ExtendedPathIndex.ExtendedPathIndex import manage_addExtendedPathIndex
    from Products.ExtendedPathIndex.ExtendedPathIndex import manage_addExtendedPathIndexForm

    context.registerClass(
        ExtendedPathIndex,
        permission='Add Pluggable Index',
        constructors=(manage_addExtendedPathIndexForm,
                      manage_addExtendedPathIndex),
        icon='www/index.gif',
        visibility=None
    )