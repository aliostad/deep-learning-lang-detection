#Testing start recording command
#Author: Witold Wasilewski

from RoboticFramework.Command.BeginRecordSessionCommand import BeginRecordSessionCommand
from DummyRobotController import DummyRobotController

class TestBeginRecordSessionCommand:
    
    def setup_method(self, method):
        self.robotController = DummyRobotController()
    
    def test_command_simple(self):
        #test if command start record session in controller
        command = BeginRecordSessionCommand()
        
        command.execute(self.robotController)
        assert self.robotController.isSessionRecordingActive
    
    def teardown_method(self, method):
        pass