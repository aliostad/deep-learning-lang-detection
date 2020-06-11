import unittest

from model.Grid import Grid
from controller.Controller import Controller

class ControllerTest(unittest.TestCase):
	
	grid = None

	def setUp(self):
		self.grid = Grid()
		self.grid.writeCell("cell content",(0,0))	
		self.grid.writeCell("one on one",(1,1))	

	def test_cell_click(self):
		"""when a cell is clicked, its text should appear 
			in the top_text"""

		controller = Controller(self.grid)

		controller.clickAt((0,0))
		self.assertEqual("cell content",controller.getTopText())


	def test_top_text_edit(self):
		controller = Controller(self.grid)
		controller.clickAt((1,1))
		controller.writeTopText("A new hope")

		self.assertEqual("A new hope", controller.getCurrentCellContent())


if __name__ == "__main__":
	unittest.main()
