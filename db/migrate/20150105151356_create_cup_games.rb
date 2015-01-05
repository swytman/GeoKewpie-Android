class CreateCupGames < ActiveRecord::Migration
  def change
    add_column :games, :home_game_id, :integer
    add_column :games, :visiting_game_id, :integer
  end
end
