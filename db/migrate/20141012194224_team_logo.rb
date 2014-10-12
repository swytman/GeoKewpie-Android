class TeamLogo < ActiveRecord::Migration
  def change
    create_table :team_logos
    add_attachment :team_logos, :logo
  end
end
