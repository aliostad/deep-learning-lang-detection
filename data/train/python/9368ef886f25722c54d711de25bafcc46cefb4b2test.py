from app.email.controller import EmailController as emailcontroller
from app.evmail.controller import EvmailController
import app.core.settings
from pprint import pprint
from app.templateset.controller import TemplatesetController as templatecontroller

import sys
sys.path.append("")

#controller = emailcontroller(settings.IMAP_HOST,settings.IMAP_PORT,settings.IMAP_USER,settings.IMAP_PASS)

#print controller.reloadAllEmails()

#controller.reloadAllEmails()

#controller = templatecontroller()
#controller.getTemplateset('discussion','0.1')

#controller = EvmailController()
tscontroller = templatecontroller()
#controller.getEvmailTemplate("discussion","message","0.1")
tscontroller.reloadTemplatesets()
