namespace :earnings do

  desc "calculate earnings"
  task :calculate => :environment do
    users = User.all
    users.each do |user|
      user.earnings = 0
      user.picks.each do |pick|
        earnings = calculate_earnings(pick)
        user.earnings += earnings
      end
      user.earnings_updated_at = DateTime.now
      user.save
      puts "updated #{user.full_name} - #{user.earnings}"
    end
  end



  def calculate_earnings(pick)
    player = pick.player
    tournament = pick.tournament
    result = Result.find_by(tournament: tournament, player: player)
    if result
      return result.money
    else
      return 0
    end
  end
end


