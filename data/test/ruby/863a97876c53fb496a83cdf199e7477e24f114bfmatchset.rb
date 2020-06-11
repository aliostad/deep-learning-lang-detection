# == Schema Information
#
# Table name: matchsets
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  map_id     :integer
#  result     :string(255)
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Matchset < ActiveRecord::Base
  # attr_accessible :title, :body
  def process
    player_a = self.left_player
    player_b = self.right_player
    if calculate_score(player_a) > calculate_score(player_b)
      self.result = 1
    elsif calculate_score(player_a) < calculate_score(player_b)
      self.result = 2
    else
      self.result = 3
    end
  end

  def calculate_score player
    rand * (100 - player.consistency) +
    calculate_map_score(player) +
    (player.macro + player.micro) * 0.5 +
    (player.tatics + player.strategy) * 0.6 +
    player.creativity
  end

  def fight
  end

  def calculate_map_score player
    100
  end
end
