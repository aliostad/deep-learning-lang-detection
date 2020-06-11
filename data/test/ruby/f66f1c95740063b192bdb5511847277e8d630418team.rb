class Team < ActiveRecord::Base
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :players
  before_save :update_calculated_fields

  def calculate_matches_played
    countries.reduce(0) { |sum, c| sum + c.matches_played }
  end

  def calculate_countries_remaining
    countries.to_a.count { |c| !c.eliminated }
  end

  def calculate_total
    calculate_points_from_countries + calculate_points_from_players
  end

  def calculate_points_from_countries
    countries.reduce(0) { |sum, c| sum + c.calculate_total }
  end

  def calculate_points_from_players
    players.reduce(0) { |sum, p| sum + p.calculate_total }
  end

  def to_s
    name
  end

  private
    def update_calculated_fields
      self.matches_played = self.calculate_matches_played
      self.countries_remaining = self.calculate_countries_remaining
      self.total = self.calculate_total
    end
end
