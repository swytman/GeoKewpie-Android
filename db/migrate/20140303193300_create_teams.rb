class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :title
      t.string :desc
      t.string :status
      t.integer :parent_team_id
      t.timestamps
    end
  end
end
