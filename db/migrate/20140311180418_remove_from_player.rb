class RemoveFromPlayer < ActiveRecord::Migration
  def change
    remove_column :players, :drafted
  end
end
