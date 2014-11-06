class AddTechLose < ActiveRecord::Migration
  def change
    add_column :games, :techlose, :boolean, default: :false
  end
end
