class AddPlaceToGames < ActiveRecord::Migration
  def change
    add_column :games, :place, :string
  end
end
