def initialize(context):
    from Products.ExtendedPathIndex.ExtendedPathIndex import ExtendedPathIndex
    from Products.ExtendedPathIndex.ExtendedPathIndex import \
        manage_addExtendedPathIndex
    from Products.ExtendedPathIndex.ExtendedPathIndex import \
        manage_addExtendedPathIndexForm

    context.registerClass(
        ExtendedPathIndex,
        permission='Add Pluggable Index',
        constructors=(manage_addExtendedPathIndexForm,
                      manage_addExtendedPathIndex),
        icon='www/index.gif',
        visibility=None)
