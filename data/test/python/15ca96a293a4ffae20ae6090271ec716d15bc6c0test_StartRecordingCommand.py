#Testing stop recording command
#Author: Witold Wasilewski

from DummyRobotController import DummyRobotController
from RoboticFramework.Command.StartRecordCommand import StartRecordCommand

class TestStopRecordingCommand:
    
    def setup_method(self, method):
        self.robotController = DummyRobotController()
    
    def test_command_simple(self):
        #test if command stop record session in controller
        command = StartRecordCommand()
        
        command.execute(self.robotController)
        assert self.robotController.isRecording
    
    def teardown_method(self, method):
        pass