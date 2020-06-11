from repository.repoSt import repoSt
from repository.repoA import repoA
from repository.memory import inMemory
from repository.fileSt import fileRepoSt
from repository.fileA import fileRepoA
from domain.validators import validateStudent, validateAssignment
from testers.testValidators import TestValidators
from testers.testStudent import TestStudent
from testers.testAssignment import TestAssignment
from ui.ui import consoleUI

print '\n'

valSt = validateStudent()
valAsg = validateAssignment()

while True :
    try:
        store = raw_input("Handling data from file (f) or memory (m)? ")
        if store not in ['f', 'm'] :
            raise Exception()
        if store == 'm' :
            repositoryAssignmnent = repoA(valAsg)
            repositoryStudent = repoSt(valSt)

            inmemory = inMemory(repositoryStudent, repositoryAssignmnent)
            inmemory.updateStudents()
            inmemory.updateAssignments()
        elif store == 'f' :
            repositoryStudent = fileRepoSt(valSt, "repository/studentsList")
            repositoryAssignmnent = fileRepoA(valAsg, repositoryStudent, "repository/assignmentsList")
        break
    except Exception:
        print "Try again!"

ui = consoleUI(repositoryStudent, repositoryAssignmnent)
ui.showMain()
