class ChangePlayersScoresType < ActiveRecord::Migration
  def change
    change_column :games, :player_scores, :string, :array => true
  end
end
