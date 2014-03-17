class AddScorePlayer < ActiveRecord::Migration
  def change
    add_column :games, :player_scores, :integer, :array => true
  end
end
