class Cell
  attr_accessor :value
  attr_reader :id, :board_size, :row, :column, :group

  def initialize(id, board_size)
    @id = id
    @board_size = board_size
    @row = calculate_row
    @column = calculate_column
    @group = calculate_group
  end

  def empty?
    value.nil?
  end

  def calculate_row
    (id / board_size) + 1
  end

  def calculate_column
    (id % board_size) + 1
  end

  def calculate_group
    group_dimension = Math.sqrt(board_size).to_i
    group_row = (row - 1) / group_dimension
    group_column = (column - 1) / group_dimension
    ((group_row * group_dimension) + group_column) + 1
  end
end