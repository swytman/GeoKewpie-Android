class AddTourToGames < ActiveRecord::Migration
  def change
    add_column :games, :tour_id, :integer
  end
end
