class AddFieldsGame < ActiveRecord::Migration
  def change
    change_column :games, :status, :string, default: "не сыгран"
    change_column :games, :time, :time, default: "19:00"
  end
end
