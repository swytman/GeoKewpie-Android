class AddTeamLogo < ActiveRecord::Migration
  def change
    add_column :teams, :team_logo_id, :integer
  end
end
