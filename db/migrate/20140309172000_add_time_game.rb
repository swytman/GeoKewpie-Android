class AddTimeGame < ActiveRecord::Migration
  def change
    add_column :games, :time, :time
  end
end
