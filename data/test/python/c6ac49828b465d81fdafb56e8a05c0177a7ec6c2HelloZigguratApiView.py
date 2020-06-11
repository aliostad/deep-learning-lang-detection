# HelloZigguratApiView.py
# (C)2013
# Scott Ernst

from ziggurat.view.api.ApiRouterView import ApiRouterView

#___________________________________________________________________________________________________ HelloZigguratApiView
class HelloZigguratApiView(ApiRouterView):
    """A class for..."""

#===================================================================================================
#                                                                                       C L A S S

#___________________________________________________________________________________________________ __init__
    def __init__(self, request, **kwargs):
        """Creates a new instance of HelloZigguratApiView."""
        super(HelloZigguratApiView, self).__init__(request, **kwargs)
