def get_area dim
    l = dim[0].to_i
    w = dim[1].to_i
    h = dim[2].to_i
    # p l
    # p w
    # p h
    result = 2*l*w + 2*w*h + 2*h*l

    sort = dim.sort
    result += sort[0] * sort[1];
    return result
end

def get_ribbon_length dim
    sort = dim.sort
    x = sort[0]
    y = sort[1]
    z = sort[2]
    l1 = x+x+y+y
    l2 = x * y * z
    l1 + l2
end

def calculate_size line
    dimensions = line.split("x").map(&:to_i)
    area = get_area dimensions
end

def calculate_ribbon line
    dimensions = line.split("x").map(&:to_i)
    area = get_ribbon_length dimensions
end

file = File.new("presents.txt", "r")
paper_size = 0
ribbon_length = 0
while (line = file.gets)
    size_needed = calculate_size(line)
    ribbon_needed = calculate_ribbon(line)
    paper_size += size_needed
    ribbon_length += ribbon_needed
end
file.close

p "Paper: " + paper_size.to_s
p "Ribbon: " + ribbon_length.to_s

# p calculate_ribbon "2x3x4"
# p calculate_ribbon "1x1x10"