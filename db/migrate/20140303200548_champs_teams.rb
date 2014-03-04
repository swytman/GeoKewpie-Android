class ChampsTeams < ActiveRecord::Migration
  def change
    create_table :champs_teams do |t|
      t.integer :champ_id
      t.integer :team_id
    end
  end
end
