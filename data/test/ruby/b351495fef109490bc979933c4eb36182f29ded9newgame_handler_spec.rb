require "newgame_handler"
require "ttt_game_handler"

describe NewgameHandler do
  let(:request) { {"Body" => {"newgame" => "easy_ai"}} }
  let(:handler) { NewgameHandler.new }
  let(:game_handler) { TTTGameHandler.new }

  describe "handle" do
    it "creates a new game" do
      game_handler.should_receive(:create_game)
      handler.handle(request, game_handler)
    end

    it "selects a new opponent" do
      game_handler.should_receive(:select_opponent).with("easy_ai")
      handler.handle(request, game_handler)
    end
  end

  it "opponent" do
    handler.opponent(request).should == "easy_ai"
  end
end
