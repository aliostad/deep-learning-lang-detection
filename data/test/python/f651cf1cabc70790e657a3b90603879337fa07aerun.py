from controller.attenting_ctrl import AttentingCtrl
from domain.validators import Validators
from repository.attenting_repository import AttendingRepositoryFile
from repository.person_repository import PersonRepositoryFile
from controller.person_ctrl import PersonCtrl
from ui.console import Console
from repository.event_repository import EventRepositoryFile
from controller.event_ctrl import EventCtrl

val = Validators()

person_repo = PersonRepositoryFile("persons.txt")
person_ctrl = PersonCtrl(val, person_repo)


event_repo = EventRepositoryFile("events.txt")
event_ctrl = EventCtrl(val, event_repo)

attend_repo = AttendingRepositoryFile("atd.txt")
attend_ctrl = AttentingCtrl(val, event_repo, person_repo, attend_repo)

cons = Console(person_ctrl, event_ctrl, attend_ctrl)
cons.startUI()