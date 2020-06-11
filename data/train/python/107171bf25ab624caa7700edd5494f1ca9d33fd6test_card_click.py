from app import *

from controllers import *
import global_mod as g

class TestSceneGraph (object):

    def __init__(self):
        self.root = None

    def initControllers(self):

        g.image_manager.card_slot = "data/img/card_slot.png"
        g.image_manager.card_back = "data/img/card_back.jpg"
        g.image_manager.card_front = "data/img/card_front.jpg"

        testController = Controller()
        testController.view = View()

        cardController = CardController()
        testController.view.children.append(cardController.view)
        cardController.view.position = Position(100,100)

        #cardSlotController = CardSlotController()
        #gameController.view.children.append(cardSlotController.view)
        #cardSlotController.view.position = Position(300,100)

        testController.rect = pygame.Rect(0,0,500,500)

        self.root = testController.view


app = App(sceneGraphClass=TestSceneGraph)
app.run()