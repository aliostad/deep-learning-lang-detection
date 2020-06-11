desc "calculate days points and adjust best score"
task :calculate_best_score => :environment do
  puts "calculating day points: start at #{Time.now.utc}"
  User.confirmed().active().each {|user|
    # we calculate it only for people whose time is midnight
    Time.zone = user.timezone
    now = Time.zone.now
    if now.hour == 0
      user.calculate_best_score()
    end
  }
	puts "calculating day points: done"
end

desc "calculate streaks"
task :calculate_streaks => :environment do
  puts "calculating streaks: start at #{Time.now.utc}"
  User.confirmed().active().each {|user|
    Time.zone = user.timezone
  	now = Time.zone.now
  	# we calculate it only for people whose time is midnight
    if now.hour == 0
    	user.calculate_streaks()
  	end
  }
	puts "calculating streaks: done"
end