class AddWinnerField < ActiveRecord::Migration
  def change
    add_column :games, :winner_id, :integer
    add_column :games, :game_home_id, :integer
    add_column :games, :game_visiting_id, :integer
  end
end
