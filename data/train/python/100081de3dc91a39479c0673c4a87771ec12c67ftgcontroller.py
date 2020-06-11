"""
This module contains the main TurboGears Controller implementation.
"""
from dispatcher          import ObjectDispatcher
from decoratedcontroller import DecoratedController

class TGController(DecoratedController, ObjectDispatcher):
    """
    TGController is a specialized form of ObjectDispatchController that forms the
    basis of standard TurboGears controllers.  The "Root" controller of a standard
    tg project must be a TGController.

    This controller can be used as a baseclass for anything in the
    object dispatch tree, but it MUST be used in the Root controller
    and any controller which you intend to do object dispatch from
    using Routes.

    This controller has a few reserved method names which provide special functionality.

    +-----------------+--------------------------------------------------------------+--------------------------------------------+
    | Method          | Description                                                  | Example URL(s)                             |
    +=================+==============================================================+============================================+
    | index           | The root of the controller.                                  | /                                          |
    +-----------------+--------------------------------------------------------------+--------------------------------------------+
    | default         | A method to call when all other methods have failed.         | /movies                                    |
    +-----------------+--------------------------------------------------------------+--------------------------------------------+
    | lookup          | Allows the developer to return a                             | /location/23.35/2343.34/elevation          |
    |                 | Controller instance for further dispatch.                    |                                            |
    +-----------------+--------------------------------------------------------------+--------------------------------------------+


    :References:

      `Controller <../main/Controllers.html>`_  A basic overview on how to write controller methods.

    """

