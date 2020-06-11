require 'pp'
class Play < Chingu::GameState
  attr_reader :chunks
  trait :viewport
  trait :timer

  def initialize
    super

    self.viewport.lag = 0

    self.input = {
      :escape => :quit
    }

    create_player

    @crosshair = Gosu::Image["crosshair.png"]
    @font = Gosu::Font.new($window, Gosu::default_font_name, 20)

    @seed = 42
    @noise = CachedNoisy.new(@seed, 4)
    if File.exists?('data.json')
      @noise.load('data.json')
    end

    @chunks = {}
    generate_chunks
  end

  def create_player
    @player = Player.create(:x => 0, :y => 0)
    @player.input = {
      #:mouse_left => :fire,
      #:mouse_right => :fire,
      :holding_a => :left,
      :holding_d => :right,
      :holding_w => :up,
      :holding_s => :down,
      :released_a => :halt_x,
      :released_d => :halt_x,
      :released_w => :halt_y,
      :released_s => :halt_y,
    }
  end

  def update
    super

    generate_chunks

    self.viewport.center_around(@player)
  end

  def chunk_coord(x, y)
    cx = (x / Chunk::WIDTH).to_i
    cx -= 1 if x < 0
    cy = (y / Chunk::HEIGHT).to_i
    cy -= 1 if y < 0
    [cx, cy]
  end

  def generate_chunks
    player_chunk = chunk_coord(@player.x, @player.y)
    (player_chunk[0]-1..player_chunk[0]+1).each do |x|
      (player_chunk[1]-1..player_chunk[1]+1).each do |y|
        unless @chunks[[x, y]]
          @chunks[[x, y]] = Chunk.new(x*Chunk::WIDTH, y*Chunk::HEIGHT, @noise)
        end
      end
    end
  end

  def draw
    super

    @crosshair.draw(
      $window.mouse_x-@crosshair.width/2,
      $window.mouse_y-@crosshair.height/2,
      200
    )
    @font.draw("FPS #{$window.fps}", 10, 10, 200)
    @font.draw("#{@player.x.to_i}, #{@player.y.to_i}", 10, 30, 200)

    player_chunk = chunk_coord(@player.x, @player.y)
    (player_chunk[0]-1..player_chunk[0]+1).each do |x|
      (player_chunk[1]-1..player_chunk[1]+1).each do |y|
        @chunks[[x, y]].draw
      end
    end
  end

  def quit
    @noise.save('data.json')
    exit
  end
end
