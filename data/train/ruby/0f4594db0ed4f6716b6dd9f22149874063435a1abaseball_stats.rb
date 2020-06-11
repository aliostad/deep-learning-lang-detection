require 'csv'
require_relative './lib/player_list'
require_relative './lib/batting_stat_sheet'
require_relative './lib/pitching_stat_sheet'

@batting_stats = BattingStatSheet.new('./import_files/Batting-07-12.csv')  #import stat lines
$player_list = PlayerList.new('./import_files/Master-small.csv') #import player names
@batting_stats.calculate_batting_average #calculate players batting averages
@batting_stats.calculate_slugging_percentage #calculate players slugging percentages
@batting_stats.calculate_batting_improvement #calculate batting average improvements over previous year
@batting_stats.triple_crown_winners(["2011", "2012"])
@batting_stats.ba_improvement_max("2010") #output most improved batting average (year)
@batting_stats.stats_by_team_and_year("OAK", "2007") #output slugging percentages (team, year)


