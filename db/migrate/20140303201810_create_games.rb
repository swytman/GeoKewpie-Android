class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_id
      t.integer :visiting_id
      t.integer :champ_id
      t.string :status
      t.date :date
      t.integer :place_id
      t.integer :home_scores
      t.integer :visiting_scores
      t.integer :home_points
      t.integer :visiting_points
      t.timestamps
    end
  end
end
