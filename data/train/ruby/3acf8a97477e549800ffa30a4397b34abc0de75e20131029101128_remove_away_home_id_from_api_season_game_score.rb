class RemoveAwayHomeIdFromApiSeasonGameScore < ActiveRecord::Migration
  def change
    remove_column :api_season_game_scores, :away_team_id, :integer
    remove_column :api_season_game_scores, :home_team_id, :integer
    remove_column :api_season_game_scores, :api_season_id, :integer
    remove_column :api_season_game_scores, :api_season_type_id, :integer
    remove_column :api_season_game_scores, :api_stadium_detail_id, :integer

    add_reference :api_season_game_scores, :api_season_schedule, :after => :id
  end
end
