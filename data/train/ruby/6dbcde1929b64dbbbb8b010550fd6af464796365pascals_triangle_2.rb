class PascalTriangle
  def initialize
    @digits = []
  end

  def calculate_row(row)
    row = row.to_f
    0.upto(row) { |column| @digits << calculate_number(row, column).to_i }
    @digits
  end

  def calculate_number(row, column)
    r = row + 1
    if column == 0
      1
    else
      previous = calculate_number(row, column-1)
      previous * ((r - column) / column)
    end
  end
end

row = 20

index = 1
while index <= row
  pc = PascalTriangle.new
  digits = pc.calculate_row(index)
  puts digits.join(', ')
  index += 1
end