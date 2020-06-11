"""Initialize CMFFormController"""

from Products.CMFCore.utils import registerIcon, ToolInit

from config import *
import ControllerPageTemplate, FSControllerPageTemplate
import ControllerPythonScript, FSControllerPythonScript
import ControllerValidator, FSControllerValidator
import FormController
from Actions import RedirectTo, TraverseTo, RedirectToAction, TraverseToAction

GLOBALS = globals()

def initialize(context):
    tools = (FormController.FormController,)
    ToolInit('Form Controller Tool',
             tools=tools,
             icon='tool.gif',
            ).initialize( context )
    context.registerClass(
        ControllerPageTemplate.ControllerPageTemplate,
        constructors=(ControllerPageTemplate.manage_addControllerPageTemplateForm,
                      ControllerPageTemplate.manage_addControllerPageTemplate),
        icon='www/cpt.gif',
        )
    context.registerClass(
        ControllerPythonScript.ControllerPythonScript,
        constructors=(ControllerPythonScript.manage_addControllerPythonScriptForm,
                      ControllerPythonScript.manage_addControllerPythonScript),
        icon='www/cpy.gif',
        )
    context.registerClass(
        ControllerValidator.ControllerValidator,
        constructors=(ControllerValidator.manage_addControllerValidatorForm,
                      ControllerValidator.manage_addControllerValidator),
        icon='www/vpy.gif',
        )
    registerIcon(FSControllerPageTemplate.FSControllerPageTemplate,
                 'www/cpt.gif', globals())
    registerIcon(FSControllerPythonScript.FSControllerPythonScript,
                 'www/cpy.gif', globals())
    registerIcon(FSControllerValidator.FSControllerValidator,
                 'www/vpy.gif', globals())
