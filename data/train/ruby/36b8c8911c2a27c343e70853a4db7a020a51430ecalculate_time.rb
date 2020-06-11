#!/usr/bin/env ruby

def calculate_time(command)
  return unless command
  puts "begin calculate time of #{command}"

  start_time = Time.now
  is_success = system(command)
  #sleep(50)
  end_time = Time.now
  consume_second = end_time - start_time
  consume_minute = (consume_second/60).to_i
  remaining_second = consume_second - consume_minute*60
  
  puts "#{command} is running #{is_success}"
  puts "calculate time is #{consume_minute} minutes and #{remaining_second} seconds"
end

if __FILE__ == $0
  command = ARGV.first
  calculate_time(command)
end
