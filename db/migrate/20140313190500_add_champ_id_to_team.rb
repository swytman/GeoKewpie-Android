class AddChampIdToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :champ_id, :integer
  end
end
