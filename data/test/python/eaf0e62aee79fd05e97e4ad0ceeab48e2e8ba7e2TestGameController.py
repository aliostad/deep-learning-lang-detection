import unittest
from GameController import *

class  TestGameControllerTestCase(unittest.TestCase):
    
    def test_canary(self):
        self.assertTrue(True)
        
    def setUp(self):
        self.gameController = GameController()

    def test_expose_cell(self):
        self.assertTrue(self.gameController.exposeCell(7, 8))
    
    def test_expose_exposed_cell(self):
        self.gameController.exposeCell(2, 8) 
        self.assertFalse(self.gameController.exposeCell(2, 8))
        
    def test_seal_cell(self):
        self.assertTrue(self.gameController.toggleSeal(2, 3)) 
		
    def test_expose_sealed_cell(self): 
        self.gameController.toggleSeal(1, 2)
        self.assertFalse(self.gameController.exposeCell(1, 2))
        
    def test_unseal_sealed_cell(self):
        self.gameController.toggleSeal(2, 3)
        self.assertTrue(self.gameController.toggleSeal(2, 3))
    
    def test_seal_exposed_cell(self):
        self.gameController.exposeCell(3, 7)
        self.assertFalse(self.gameController.toggleSeal(3, 7))      
    
    def test_count_mines_next_to_empty_cell(self):
        self.assertEquals(0, self.gameController.countMines(8, 9))
        
    def test_count_mines_for_cell_next_to_1_mine(self):
        self.gameController.setMine(5, 4)
        self.assertEquals(1, self.gameController.countMines(5, 5))
    
    def test_count_mines_for_cell_next_to_2_mines(self):
        self.gameController.setMine(5, 4)
        self.gameController.setMine(5, 6)
        self.assertEquals(2, self.gameController.countMines(5, 5))
        
    def test_count_mines_for_cell_next_to_3_mines(self):
        self.gameController.setMine(5, 4)
        self.gameController.setMine(5, 6)
        self.gameController.setMine(4, 4)
        self.assertEquals(3, self.gameController.countMines(5, 5))
        
    def test_count_mines_for_cell_next_to_4_mines(self):
        self.gameController.setMine(5, 4)
        self.gameController.setMine(5, 6)
        self.gameController.setMine(4, 4)
        self.gameController.setMine(4, 5)
        self.assertEquals(4, self.gameController.countMines(5, 5))
        
    def test_count_mines_for_cell_next_to_5_mines(self):
        self.gameController.setMine(5, 4)
        self.gameController.setMine(5, 6)
        self.gameController.setMine(4, 4)
        self.gameController.setMine(4, 5)
        self.gameController.setMine(4, 6)
        self.assertEquals(5, self.gameController.countMines(5, 5))
        
    def test_count_mines_for_cell_next_to_6_mines(self):
        self.gameController.setMine(5, 4)
        self.gameController.setMine(5, 6)
        self.gameController.setMine(4, 4)
        self.gameController.setMine(4, 5)
        self.gameController.setMine(4, 6)
        self.gameController.setMine(6, 4)
        self.assertEquals(6, self.gameController.countMines(5, 5))
        
    def test_count_mines_for_cell_next_to_7_mines(self):
        self.gameController.setMine(5, 4)
        self.gameController.setMine(5, 6)
        self.gameController.setMine(4, 4)
        self.gameController.setMine(4, 5)
        self.gameController.setMine(4, 6)
        self.gameController.setMine(6, 4)
        self.gameController.setMine(6, 5)
        self.assertEquals(7, self.gameController.countMines(5, 5))
        
    def test_count_mines_for_cell_next_to_8_mines(self):
        self.gameController.setMine(5, 4)
        self.gameController.setMine(5, 6)
        self.gameController.setMine(4, 4)
        self.gameController.setMine(4, 5)
        self.gameController.setMine(4, 6)
        self.gameController.setMine(6, 4)
        self.gameController.setMine(6, 5)
        self.gameController.setMine(6, 6)
        self.assertEquals(8, self.gameController.countMines(5, 5))
    
    def test_exposing_cells_on_an_empty_board(self):
        counter = 0
        self.gameController.recursiveExposeEmptyCells(5,5)
        for x in range (self.gameController.getSize()):
            for y in range (self.gameController.getSize()):
                if (self.gameController.isExposed(x,y) == True):
                    counter +=1
        self.assertEquals(100, counter)

    
    def test_exposing_cells_on_1_mine_board(self):
        counter = 0
        self.gameController.setMine(0,0)
        self.gameController.recursiveExposeEmptyCells(9, 0)
        for x in range (0, self.gameController.getSize()):
            for y in range (0, self.gameController.getSize()):
                if (self.gameController.isExposed(x,y) == True):
                    counter +=1
        self.assertEquals(99, counter) 
    
    def test_exposing_cells_on_a_group_of_5_mines_board(self):
        counter = 0
        self.gameController.setMine(0,0)
        self.gameController.setMine(0,1)
        self.gameController.setMine(0,2)
        self.gameController.setMine(0,3)
        self.gameController.setMine(0,4)
        self.gameController.recursiveExposeEmptyCells(9, 0)
        for x in range (0, self.gameController.getSize()):
            for y in range (0, self.gameController.getSize()):
                if (self.gameController.isExposed(x,y) == True):
                    counter +=1
        self.assertEquals(95, counter)
    
    def test_exposing_on_1_sealed_cell_board(self):
        counter = 0
        self.gameController.toggleSeal(1, 1)
        self.gameController.recursiveExposeEmptyCells(1, 2)
        for x in range (0, self.gameController.getSize()):
            for y in range (0, self.gameController.getSize()):
                if (self.gameController.isExposed(x,y) == True):
                    counter +=1
        self.assertEquals(99, counter)
    
    def test_exposing_on_5_sealed_cell_board(self):
        counter = 0
        self.gameController.toggleSeal(1, 1)
        self.gameController.toggleSeal(9, 3)
        self.gameController.toggleSeal(5, 1)
        self.gameController.toggleSeal(4, 1)
        self.gameController.toggleSeal(3, 1)
        self.gameController.recursiveExposeEmptyCells(9, 0)
        for x in range (0, self.gameController.getSize()):
            for y in range (0, self.gameController.getSize()):
                if (self.gameController.isExposed(x,y) == True):
                    counter +=1
        self.assertEquals(95, counter)
        
    def test_is_game_over_if_exposed_mined_cell(self):
        self.gameController.setMine(1,1)
        self.gameController.exposeCell(1,1)
        self.assertTrue(self.gameController.isGameOver(1,1))
    
    def test_is_game_over_if_exposed_non_mined_cell(self):
        self.gameController.exposeCell(4,5)
        self.assertFalse(self.gameController.isGameOver(4,5))
    
    def test_win_game_if_sealed_all_existing_mines_and_exposed_the_rest(self):
        self.gameController.setMine(0,0)
        self.gameController.setMine(0,1)
        self.gameController.toggleSeal(0,0)
        self.gameController.toggleSeal(0,1)
        self.gameController.recursiveExposeEmptyCells(9,0)
        self.assertTrue(self.gameController.winGame())

    def test_win_game_if_mine_is_not_sealed_yet(self):
        self.gameController.setMine(0,0)
        self.gameController.recursiveExposeEmptyCells(9,9)
        self.assertFalse(self.gameController.winGame())
        
if __name__ == '__main__':
    unittest.main()

