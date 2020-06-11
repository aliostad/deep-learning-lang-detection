from generalController import GeneralController
from caseController import CaseController
from taskController import TaskController
from forensicsController import ForensicsController
from userController import UserController
from evidenceController import EvidenceController
from reportController import ReportController
from exportController import ExportController

controller_lookup = {
               'general': GeneralController,
               'case': CaseController,
               'task': TaskController,
               'forensics': ForensicsController,
               'user': UserController,
               'evidence': EvidenceController,
               'report': ReportController,
               'export': ExportController
               }
