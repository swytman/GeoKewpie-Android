class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :player_id
      t.integer :team_id
      t.date :join_date
      t.date :leave_date
      t.timestamps
    end
  end
end
