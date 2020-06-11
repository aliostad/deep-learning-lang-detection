'use strict';

describe('Controller: MinesweeperController', function () {

  // load the controller's module
  beforeEach(function () {
    module('minesweeperAppInternal');

    //add your mocks here
  });

  var MinesweeperController;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller) {
    MinesweeperController = $controller('MinesweeperController');
  }));

  it('Should have a number of rows, cols, mines and a minesweeper board', function () {
    expect(MinesweeperController.minesweeperBoard).toBeDefined();
    expect(MinesweeperController.rows).toBeDefined();
    expect(MinesweeperController.cols).toBeDefined();
    expect(MinesweeperController.mines).toBeDefined();
  });

});
