#The easiest way to do it would be probably to iterate through all the numbers, turn them to a string, split it and feed it to a counting machine

$indexes_to_calculate = [1, 10, 100, 1000, 10000, 100000, 1000000, 999999999999999999999999999]
#$indexes_to_calculate = [13, 17, 1000000000000]

$current_d_to_calculate = $indexes_to_calculate.shift

$current_d = 1

$list_of_ds = []

i = 1

def calculate(d)
	if $current_d == $current_d_to_calculate
		$list_of_ds << d
		$current_d_to_calculate = $indexes_to_calculate.shift
	end
	$current_d += 1
end

while $indexes_to_calculate.size > 0
	digits = i.to_s.split(//)
	digits.each do |d| 
		calculate(d)
	end
	i+=1
end

p $list_of_ds

p $list_of_ds.inject(1) {|result, elem| result *= elem.to_i}

