class AddChampGroup < ActiveRecord::Migration
  def change
    add_column :champs, :group_key, :string
  end
end
