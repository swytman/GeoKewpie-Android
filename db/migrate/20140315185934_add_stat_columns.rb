class AddStatColumns < ActiveRecord::Migration
  def change
    add_column :games, :yellow_cards, :integer, :array => true
    add_column :games, :dbl_yellow_cards, :integer, :array => true
    add_column :games, :red_cards, :integer, :array => true
    add_column :games, :home_players, :integer, :array => true
    add_column :games, :visiting_players, :integer, :array => true
  end
end
