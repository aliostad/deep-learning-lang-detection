import sys
sys.dont_write_bytecode = True

from eventmanager.EventManager import EventManager
from controller.KeyboardController import KeyboardController
from controller.CPUSpinnerController import CPUSpinnerController
from view.PygameView import PygameView
from model.Game import Game


def main():
	evManager = EventManager()

	keybd = KeyboardController(evManager)
	spinner = CPUSpinnerController(evManager)
	pygameView = PygameView(evManager)
	game = Game(evManager)
	
	spinner.Run()

if __name__ == "__main__":
	main()