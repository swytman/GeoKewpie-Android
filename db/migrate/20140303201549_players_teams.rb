class PlayersTeams < ActiveRecord::Migration
  def change
    create_table :players_teams do |t|
      t.integer :player_id
      t.integer :team_id
      t.date :join_date
      t.date :leave_date
    end
  end
end
