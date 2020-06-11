from core import GraphicsController
from core import GameController
from core import Input
from java.util import Random


#internal variables
sys_graphicsController = GraphicsController()
sys_gameController = GameController()
sys_inputController = Input()
sys_random = Random()

def random():
	return sys_random.nextDouble()
def drawRectangle(x, y, width, height):
	global sys_graphicsController
	sys_graphicsController.drawRectangle(x, y, width, height)

def drawCircle(x, y, radius):
	global sys_graphicsController
	sys_graphicsController.drawCircle(x, y, radius)

def drawLine(x1, y1, x2, y2):
	global sys_graphicsController
	sys_graphicsController.drawLine(x1, y1, x2, y2)

def drawPoint(x, y):
	global sys_graphicsController
	sys_graphicsController.drawPoint(x, y)

def drawString(x, y, string):
	global sys_graphicsController
	sys_graphicsController.drawString(x, y, string)

def useColour(r, g, b, a):
	global sys_graphicsController
	sys_graphicsController.useColour(r, g, b, a)

def clearScreen():
	global sys_graphicsController
	sys_gameController.clearScreen()

def newFrame():
	global sys_graphicsController
	sys_gameController.newFrame()
	clearScreen()

def isMouseDown():
	global sys_inputController
	return sys_inputController.isMouseDown()

def isKeyDown(key):
	global sys_inputController
	return sys_inputController.isKeyDown(key)

#variables updated by backend
_mouseX = 0
_mouseY = 0
_screenWidth = 640
_screenHeight = 480