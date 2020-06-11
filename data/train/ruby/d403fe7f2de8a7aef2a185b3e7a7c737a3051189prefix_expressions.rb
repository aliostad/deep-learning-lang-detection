OPERATORS = %w{+ - * /}

def calculate(arr)
    if !OPERATORS.include?(arr[1])
        case arr[0]
        when "+"
            [arr[1].to_i + arr[2].to_i] + arr[3..-1]
        when "-"
            [arr[1].to_i - arr[2].to_i] + arr[3..-1]
        when "*"
            [arr[1].to_i * arr[2].to_i] + arr[3..-1]
        when "/"
            [arr[1].to_i / arr[2].to_i] + arr[3..-1]
        end
    else
        calculate( [arr.shift] + calculate(arr) )
    end
end

File.open(ARGV[0]).each_line do |line|
    puts calculate(line.chomp.split(" "))
end
