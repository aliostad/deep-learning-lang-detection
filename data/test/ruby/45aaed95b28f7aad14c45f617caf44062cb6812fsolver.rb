def calculate_area(l, w, h)
  # NOTE: The sides come sorted
  smallest_side = l*w
  side_1 = 2*smallest_side
  side_2 = 2*w*h
  side_3 = 2*h*l

  side_1 + side_2 + side_3 + smallest_side
end

def calculate_ribbon(l, w, h)
  2*(l + w) + l*w*h
end

def init
  total_area = 0
  total_ribbon = 0

  File.open('input').each do |line|
    l,w,h = line.chomp.split('x').map(&:to_i).sort

    total_area += calculate_area l, w, h
    total_ribbon += calculate_ribbon l, w, h
  end

  [total_area, total_ribbon]
end

puts "#{init}"
