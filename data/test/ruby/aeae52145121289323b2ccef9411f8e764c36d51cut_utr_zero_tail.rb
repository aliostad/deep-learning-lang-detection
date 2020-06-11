utrs = ARGF.readlines.map(&:chomp)
window_size = 5
result = utrs.each_slice(4).map do |chunk|
  cages = chunk[3].split.map(&:to_i)
  max_cage_in_window = cages.each_cons(window_size).map{|window| window.inject(&:+) }.max
  drop_size = cages.each_cons(window_size).take_while{|window| window.inject(&:+) < 0.1 * max_cage_in_window }.size
  [ chunk[0],
    chunk[1][drop_size..-1],
    chunk[2].split(' ')[drop_size..-1].join(' '),
    chunk[3].split(' ')[drop_size..-1].join(' ') ].join("\n")
end

puts result.join("\n")
