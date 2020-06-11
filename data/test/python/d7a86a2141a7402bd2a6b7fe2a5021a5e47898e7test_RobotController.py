#Tests for RobotController
#Author: Witold Wasilewski 2011

from RoboticFramework.RobotController.RobotController import RobotController
from RoboticFramework.RobotModelBounder import RobotModelBounder
from RoboticFramework.RobotArm import RobotArm
from config import Config
from RoboticFramework.RobotController.Delegate.RobotControllerRecordingDelegate import RobotControllerRecordingDelegate
from RoboticFramework.RobotController.Event.NewPositionEvent import NewPositionEvent

class TestRobotController:
    
    def setup_method(self, method):
        
        configuration = Config( "settings.cfg" )
        initPositions = configuration.initPositions
        constrainments = configuration.constrainments
        maxSpeed = configuration.maxSpeed
        accuracy = configuration.accuracy

        robotArm = RobotArm( initPositions, constrainments, maxSpeed, accuracy )

        #init model bounder
        robotModelBounder = RobotModelBounder( robotArm, [], 0, 0 )

        #setup robotController
        self.robotController = RobotController(robotArm, robotModelBounder, lambda: True )
    
    def test_startRecording_simple(self):
        self.robotController.startRecording()
        
        assert self.robotController.isRecording
        
    def test_stopRecording_simple(self):
        self.robotController.startRecording()
        self.robotController.stopRecording()
        assert not self.robotController.isRecording

    def test_addDelegate_simple(self):
        delegate = RobotControllerRecordingDelegate()
        self.robotController.addDelegate(delegate)
        assert self.robotController.hasDelegate(delegate)
    
    def test_removeDelegate_simple(self):
        delegate = RobotControllerRecordingDelegate()
        self.robotController.addDelegate(delegate)
        self.robotController.removeDelegate(delegate)
        assert not self.robotController.hasDelegate(delegate)
        
    def test_invokeDelagate_1(self):
        delegate = RobotControllerRecordingDelegate()
        delegate.recording = True
        self.robotController.addDelegate(delegate)
        event = NewPositionEvent("data")
        
        self.robotController.invokeEvent(event)
        
        assert delegate.sequence.amount() == 1
    
    def test_invokeDelegate_Many(self):
        delegate = RobotControllerRecordingDelegate()
        delegate.recording = True
        delegate2 = RobotControllerRecordingDelegate()
        delegate2.recording = True
        self.robotController.addDelegate(delegate)
        self.robotController.addDelegate(delegate2)
        event = NewPositionEvent("data")
        
        self.robotController.invokeEvent(event)
        
        assert delegate.sequence.amount() == 1
        assert delegate2.sequence.amount() == 1
    
    def teardown_method(self, method):
        del self.robotController