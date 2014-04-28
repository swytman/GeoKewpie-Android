class ChangeDefaultGameStatus < ActiveRecord::Migration
  def change
    change_column :games, :status, :string, :default => 'empty'
  end
end
