class AddDefaultsTeam < ActiveRecord::Migration
  def change
    change_column :teams, :win, :integer, default: 0
    change_column :teams, :lose, :integer, default: 0
    change_column :teams, :draw, :integer, default: 0
    change_column :teams, :scored, :integer, default: 0
    change_column :teams, :missed, :integer, default: 0
    change_column :teams, :points, :integer, default: 0
  end
end
