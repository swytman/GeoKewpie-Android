class GamesPlayerScores < ActiveRecord::Migration
  def change
    create_table :games_players_score do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :team_id
      t.integer :score
      t.integer :yellowcards
      t.integer :redcards
      t.integer :assists
    end
  end
end
