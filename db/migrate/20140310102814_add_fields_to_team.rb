class AddFieldsToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :win, :integer
    add_column :teams, :lose, :integer
    add_column :teams, :draw, :integer
    add_column :teams, :scored, :integer
    add_column :teams, :missed, :integer
    add_column :teams, :points, :integer
  end
end
