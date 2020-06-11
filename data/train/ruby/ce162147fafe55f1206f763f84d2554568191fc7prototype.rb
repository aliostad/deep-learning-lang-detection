require 'thread'
require 'json'

class Simulation
  attr_reader :chunk_size, :width, :height

  def initialize(chunk_size, width, height)
    @chunk_size = chunk_size
    @width = width
    @height = height

    @grid = create_grid
    @next_grid = create_grid

    @mutex = Mutex.new
  end

  def grid_offset(x, y)
    i = x / @chunk_size
    j = y / @chunk_size
    i * @height + j
  end

  def chunk_offset(x, y)
    i_offset = y % @chunk_size
    j_offset = x % @chunk_size
    i_offset * @chunk_size + j_offset
  end

  def get(x, y)
    @grid[grid_offset(x, y)][chunk_offset(x, y)]
  end

  def set(x, y, value)
    @grid[grid_offset(x, y)][chunk_offset(x, y)] = value
  end

  def clear
    @grid.each do |chunk|
      for i in 0 ... chunk.size
        chunk[i] = 0
      end
    end
  end

  def step
    for i in 0 ... @width
      for j in 0 ... @height
        hi_l = @height * ((i - 1) % @width)
        hi_r = @height * ((i + 1) % @width)
        hi = @height * i
        j_t = (j - 1) % @height
        j_b = (j + 1) % @height

        chunk_step(@next_grid[hi + j], 
            @grid[hi_l + j_t], @grid[hi + j_t], @grid[hi_r + j_t], 
            @grid[hi_l + j  ], @grid[hi + j  ], @grid[hi_r + j  ], 
            @grid[hi_l + j_b], @grid[hi + j_b], @grid[hi_r + j_b])
      end
    end

    # swap grids
    @mutex.synchronize do
      @grid, @next_grid = @next_grid, @grid
    end
  end

  def display
    for j in 0 ... @height
      for i_offset in 0 ... @chunk_size
        for i in 0 ... @width
          chunk = @grid[i * @height + j]
          for offset in (i_offset * @chunk_size) ... ((i_offset+1) * @chunk_size)
            if chunk[offset] == 0
              print '.'
            elsif chunk[offset] == 2
              print '!'
            else
              print 'X'
            end
          end
        end
        puts
      end
    end
  end

  def to_json
    json = "["
    @mutex.synchronize do
    for j in 0 ... @height
      for i_offset in 0 ... @chunk_size
        for i in 0 ... @width
          chunk = @grid[i * @height + j]
          for offset in (i_offset * @chunk_size) ... ((i_offset+1) * @chunk_size)
            if chunk[offset] == 0
              json += '0,'
            else
              json += '1,'
            end
          end
        end
      end
    end
    end
    json += '0]'
    return json
  end

private

  def chunk_step(next_chunk, 
      chunk_lt, chunk_ct, chunk_rt,
      chunk_lm, chunk_cm, chunk_rm, 
      chunk_lb, chunk_cb, chunk_rb)
    # chunk internal
    offset_t = 1
    offset_m = 1 + @chunk_size
    offset_b = 1 + @chunk_size + @chunk_size
    (chunk_size - 2).times do
      (chunk_size - 2).times do
        offset_t = offset_m - @chunk_size
        offset_b = offset_m + @chunk_size
        next_chunk[offset_m] = transition(
          chunk_cm[offset_t - 1], chunk_cm[offset_t], chunk_cm[offset_t + 1], 
          chunk_cm[offset_m - 1], chunk_cm[offset_m], chunk_cm[offset_m + 1],
          chunk_cm[offset_b - 1], chunk_cm[offset_b], chunk_cm[offset_b + 1])
        offset_m += 1
      end
      offset_m += 2
    end

    # chunk sides
    offset_lm = @chunk_size
    offset_rm = @chunk_size*2 - 1
    offset_tm = 1
    offset_bm = @chunk_size * (@chunk_size - 1) + 1
    (chunk_size - 2).times do
      offset_lt = offset_lm - @chunk_size
      offset_lb = offset_lm + @chunk_size
      offset_rt = offset_rm - @chunk_size
      offset_rb = offset_rm + @chunk_size
      offset_t = offset_tm - @chunk_size
      offset_tb = offset_tm + @chunk_size
      offset_rt = offset_rm - @chunk_size
      offset_rb = offset_rm + @chunk_size
      
      next_chunk[offset_lm] = transition(
         chunk_lm[offset_rt], chunk_cm[offset_lt], chunk_cm[offset_lt + 1],
         chunk_lm[offset_rm], chunk_cm[offset_lm], chunk_cm[offset_lm + 1],
         chunk_lm[offset_rb], chunk_cm[offset_lb], chunk_cm[offset_lb + 1])
      next_chunk[offset_rm] = transition(
         chunk_cm[offset_rt - 1], chunk_cm[offset_rt], chunk_rm[offset_lt],
         chunk_cm[offset_rm - 1], chunk_cm[offset_rm], chunk_rm[offset_lm],
         chunk_cm[offset_rb - 1], chunk_cm[offset_rb], chunk_rm[offset_lb])

      offset_tb = offset_tm + @chunk_size
      offset_bt = offset_bm - @chunk_size
      next_chunk[offset_tm] = transition(
          chunk_ct[offset_bm - 1], chunk_ct[offset_bm], chunk_ct[offset_bm + 1], 
          chunk_cm[offset_tm - 1], chunk_cm[offset_tm], chunk_cm[offset_tm + 1],
          chunk_cm[offset_tb - 1], chunk_cm[offset_tb], chunk_cm[offset_tb + 1])
      next_chunk[offset_bm] = transition(
          chunk_cm[offset_bt - 1], chunk_cm[offset_bt], chunk_cm[offset_bt + 1], 
          chunk_cm[offset_bm - 1], chunk_cm[offset_bm], chunk_cm[offset_bm + 1],
          chunk_cb[offset_tm - 1], chunk_cb[offset_tm], chunk_cb[offset_tm + 1])

      offset_lm += @chunk_size
      offset_rm += @chunk_size
      offset_tm += 1
      offset_bm += 1
    end

    # chunk corners
    m = @chunk_size - 1
    next_chunk[index(0, 0)] = transition(
          chunk_lt[index(m, m)], chunk_ct[index(m, 0)], chunk_ct[index(m, 1)], 
          chunk_lm[index(0, m)], chunk_cm[index(0, 0)], chunk_cm[index(0, 1)],
          chunk_lm[index(1, m)], chunk_cm[index(1, 0)], chunk_cm[index(1, 1)])
    next_chunk[index(0, m)] = transition(
          chunk_ct[index(m, m-1)], chunk_ct[index(m, m)], chunk_rt[index(m, 0)], 
          chunk_cm[index(0, m-1)], chunk_cm[index(0, m)], chunk_rm[index(0, 0)],
          chunk_cm[index(1, m-1)], chunk_cm[index(1, m)], chunk_rm[index(1, 0)])
    next_chunk[index(m, 0)] = transition(
          chunk_lm[index(m-1, m)], chunk_cm[index(m-1, 0)], chunk_cm[index(m-1, 1)], 
          chunk_lm[index(m, m)], chunk_cm[index(m, 0)], chunk_cm[index(m, 1)],
          chunk_lb[index(0, m)], chunk_cb[index(0, 0)], chunk_cb[index(0, 1)])
    next_chunk[index(m, m)] = transition(
          chunk_cm[index(m-1, m-1)], chunk_cm[index(m-1, m)], chunk_rm[index(m-1, 0)], 
          chunk_cm[index(m, m-1)], chunk_cm[index(m, m)], chunk_rm[index(m, 0)],
          chunk_cb[index(0, m-1)], chunk_cb[index(0, m)], chunk_rb[index(0, 0)])
  end

  def transition(cell_lt, cell_ct, cell_rt, 
                 cell_lm, cell_cm, cell_rm,
                 cell_lb, cell_cb, cell_rb)
    alive_cells = cell_lt + cell_ct + cell_rt + cell_lm + cell_rm + cell_lb + cell_cb + cell_rb
    case cell_cm
      when 0 # dead
        (alive_cells == 3) ? 1 : 0
      when 1 # alive
        (alive_cells == 2 || alive_cells == 3) ? 1 : 0 
    end
  end

=begin
  [0, 3] -> 1
  [0, *] -> 0
  [1, 2] -> 1
  [1, 3] -> 1
  [1, *] -> 0
=end

  def create_grid
    Array.new(@width * @height) do
      Array.new(@chunk_size * @chunk_size) do
        0
      end
    end
  end

  def index(i, j)
    i * @chunk_size + j
  end

end


class PlaceAction
  def initialize(cells)
    @cells = cells
  end

  def apply(simulation)
    for cell in @cells
      simulation.set(cell['x'], cell['y'], 1)
    end
  end
end

class ClearAction
  def apply(simulation)
    simulation.clear
  end
end

if __FILE__ == $0
  simulation = Simulation.new(10, 8, 4)

  # glider
  simulation.set(3, 3, 1)
  simulation.set(4, 3, 1)
  simulation.set(4, 5, 1)
  simulation.set(5, 3, 1)
  simulation.set(5, 4, 1)

=begin
........................O........... 
......................O.O........... 
............OO......OO............OO 
...........O...O....OO............OO 
OO........O.....O...OO.............. 
OO........O...O.OO....O.O........... 
..........O.....O.......O........... 
...........O...O.................... 
............OO......................
=end

  actions_queue = Queue.new

  Thread.start do
    loop do
      # simulation.display

      size = actions_queue.size
      for i in 0 ... size
        action = actions_queue.pop
        action.apply(simulation)
        action = nil
      end

      simulation.step

      sleep(0.2)
    end
  end

  require 'webrick'

  root_path = File.expand_path('public')
  server = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => root_path)

  server.mount_proc('/grid.json') do |request, response|
    response.body = simulation.to_json
  end

  server.mount_proc('/place') do |request, response|
    cells = JSON.parse(request.body)
    actions_queue.push(PlaceAction.new(cells))
  end

  server.mount_proc('/clear') do |request, response|
    actions_queue.push(ClearAction.new)
  end

  trap 'INT' do 
    server.shutdown
  end
  server.start

end
