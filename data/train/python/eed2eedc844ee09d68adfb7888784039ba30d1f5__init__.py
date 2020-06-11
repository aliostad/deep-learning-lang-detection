#
def initialize(context):
    """Initializer called when used as a Zope 2 product."""
    from collective.geo.index.geometryindex import GeometryIndex
    from collective.geo.index.geometryindex import manage_addGeometryIndex
    from collective.geo.index.geometryindex import manage_addGeometryIndexForm

    context.registerClass(GeometryIndex,
                          permission='Add Pluggable Index',
                          constructors=(manage_addGeometryIndexForm,
                                        manage_addGeometryIndex),
                          icon='www/index.gif',
                          visibility=None,
                         )
