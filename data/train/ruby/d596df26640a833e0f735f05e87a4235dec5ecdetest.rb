def puts(*args)
  STDOUT.puts args
  STDOUT.flush
end

args = ARGV.clone
ARGV.clear

puts 'ruby process arg1: '<<gets.chop
puts 'ruby process arg2: '<<gets.chop
puts 'ruby process arg3: '<<gets.chop



# puts 'wtf'
# puts "hello\ntest"

# puts 'ruby process args: '<<args.to_s

# puts 'ruby process begin'
# sleep 2
# puts 'ruby process input 1 test'

# inp1 = gets.chop
# puts 'ruby process input 1: '<<inp1

# sleep 2

# puts 'ruby process input 2 test'

# inp2 = gets.chop
# puts 'ruby process input 2: '<<inp2

# sleep 2
# puts 'ruby process end'