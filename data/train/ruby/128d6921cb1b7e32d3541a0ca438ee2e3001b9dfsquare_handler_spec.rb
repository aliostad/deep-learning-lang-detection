require "square_handler"
require "ttt_game_handler"

describe SquareHandler do
  let(:request) { {"Body" => {"square" => "1"}} }
  let(:square_handler) { SquareHandler.new }
  let(:game_handler) { TTTGameHandler.new }

  it "handles the request" do
    square_handler.handle(request, game_handler)
    game_handler.game_runner.game.board.square(1).should_not be_nil
  end

  it "makes a move" do
    game_handler.should_receive(:make_move).with(1)
    square_handler.make_move(1, game_handler)
  end

  it "extracts the square" do
    square_handler.extract_square(request).should == 1
  end
end
