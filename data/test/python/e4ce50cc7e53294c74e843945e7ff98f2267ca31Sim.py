#Frontier simulator 
from FrontierController import FrontierController
from TestAgent import TestAgent
from FarsiteProducer import FarsiteProducer
from TestScorer import TestScorer
from Visualizer import Visualizer
from HotspotFilter import HotspotFilter
from FovFilter import FovFilter
import time

agent1 = TestAgent()
agent2 = TestAgent()
frontierFilter = HotspotFilter()
agentFilter = FovFilter()

frontierProducer = FarsiteProducer()
scorer = TestScorer()
i = 0
frontierController = FrontierController(scorer,frontierProducer,[agent1, agent2], [frontierFilter, agentFilter])
visualizer = Visualizer()

while(i < 10000): #frontierController.hasData()):
    frontierController.tick()
    visualizer.vis(frontierController.frontierData, frontierController.agentLocations) # ,frontierController.fov, frontierController.AgentLoc)
    i = i +1
