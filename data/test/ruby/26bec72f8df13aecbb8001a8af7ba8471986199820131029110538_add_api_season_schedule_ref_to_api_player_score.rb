class AddApiSeasonScheduleRefToApiPlayerScore < ActiveRecord::Migration
  def change
    add_column :api_player_scores, :api_season_schedule_id, :integer, :after => :api_stadium_detail_id

    add_column :api_season_game_scores, :away_team_id, :integer, :after => :id
    add_column :api_season_game_scores, :home_team_id, :integer, :after => :away_team_id
    add_column :api_season_game_scores, :api_season_id, :integer, :after => :home_team_id
    add_column :api_season_game_scores, :api_season_type_id, :integer, :after => :api_season_id
    add_column :api_season_game_scores, :api_stadium_detail_id, :integer, :after => :api_season_type_id
  end
end
