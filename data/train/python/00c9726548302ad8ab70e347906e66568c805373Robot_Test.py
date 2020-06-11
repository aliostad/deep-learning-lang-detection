from NeuroRobot.Sim import Robot
from NeuroRobot.Controller import Controller
from numpy.testing.utils import assert_allclose

class MockController(Controller):
    def setStep(self,v,a):
        self.v = v
        self.a = a
        
    def step(self,sensorinput):
        return (self.v,self.a)

controller = MockController()
robot = Robot(controller)

def testRobotDoesntMoveWithZeroVelocity():
    controller.setStep(0, 0)
    robot.step()
    assert robot.position == [0,0]
    
    
def testRobotMoves1MWithOneVelocity():
    controller.setStep(1, 0)
    for i in range(0,60):
        robot.step()
    print(robot.position)
    assert_allclose(robot.position,[1,0])