class RenameChampTypeColumn < ActiveRecord::Migration
  def change
    rename_column :champs, :type, :champ_type
  end
end
