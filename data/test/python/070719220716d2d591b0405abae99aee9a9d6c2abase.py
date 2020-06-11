# -*- Mode: Python -*-
# vi:si:et:sw=4:sts=4:ts=4

"""
Base classes for model/view/controller.
"""

from dad.extern.log import log

# base class for model


class Model(object):
    """
    I am a base class for models.
    I hold data that can be presented in a view through
    the controller.

    I can notify views of changes through the controller.

    @type controller: L{Controller}
    """

    controller = None


class View(log.Loggable):
    """
    I am a base class for views.

    The controller sets itself on me when added through addView.

    @type controller: L{Controller}
    """

    controller = None

    # FIXME: error ?


class Controller(log.Loggable):
    """
    I am a base class for controllers.
    I interact with one model and one or more views.

    Controllers can be nested to form an application hierarchy.

    Controllers have a reference to their model.

    Controllers can invoke methods on all views.

    @type parent: L{Controller}
    """

    parent = None

    # FIXME: self._model is used in subclasses

    def __init__(self, model):
        """
        Sets the model's controller to self.

        @type  model: L{Model}
        """
        self._model = model
        model.controller = self

        self._views = []
        self._controllers = []

    ### base class methods

    def addView(self, view):
        """
        Adds the view to the controller.
        Will also set the view's controller to self.

        @type  view: L{View}
        """
        self._views.append(view)
        view.controller = self
        self.viewAdded(view)

    def doViews(self, method, *args, **kwargs):
        """
        Call the given method on all my views, with the given args and kwargs.
        """
        for view in self._views:
            m = getattr(view, method)
            m(*args, **kwargs)

    def add(self, controller):
        """
        Add a child controller to me.
        Takes parentship over the controller.

        @type controller: subclass of L{Controller}
        """
        self._controllers.append(controller)
        controller.parent = self

    def getRoot(self):
        """
        Get the root controller for this controller.

        @rtype: subclass of L{Controller}
        """
        parent = self.parent
        while parent.parent:
            parent = parent.parent

        return parent

    ### subclass methods

    def viewAdded(self, view):
        """
        This method is called after a view is added.
        It can be used to connect to signals on the view.

        @type  view: L{View}
        """
        pass
