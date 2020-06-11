require "rspec"
require './input_handler'
require './master_mind'

describe InputHandler do

  it "handles all sorts of inputs when setting the size of the board" do
    game = Master_mind
    InputHandler.inputHandlerSizeOfSolution("go dog go", game).should == 1
    InputHandler.inputHandlerSizeOfSolution("EScaPE", game).should == 0
    InputHandler.inputHandlerSizeOfSolution("1 2 3", game).should == 1
    InputHandler.inputHandlerSizeOfSolution("10", game).should == 2
    InputHandler.inputHandlerSizeOfSolution("2", game).should == 2
    InputHandler.inputHandlerSizeOfSolution("8", game).should == 3
  end

  it "handles all sorts of inputs when getting a guess" do
    game = Master_mind
    game.setSolutionArray([2, 3, 4])
    InputHandler.inputHandlerGuessInput("go dog go", game).should == 1
    InputHandler.inputHandlerGuessInput("EScaPE", game).should == 0
    InputHandler.inputHandlerGuessInput("1 2 3", game).should == 3
    InputHandler.inputHandlerGuessInput("10 3 5", game).should == 2
    InputHandler.inputHandlerGuessInput("2", game).should == 1
    InputHandler.inputHandlerGuessInput("8", game).should == 1
  end

end