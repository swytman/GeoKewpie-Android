class AddDisqualification < ActiveRecord::Migration
  def change
    add_column :contracts, :games, :integer, default: 0
    add_column :contracts, :goals, :integer, default: 0
    add_column :contracts, :y_cards, :integer, default: 0
    add_column :contracts, :dbl_cards, :integer, default: 0
    add_column :contracts, :r_cards, :integer, default: 0
    add_column :contracts, :disq_games, :integer, default: 0
  end
end
