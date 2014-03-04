class GamesReferees < ActiveRecord::Migration
  def change
    create_table :games_referees do |t|
      t.integer :game_id
      t.integer :referee_id
    end
  end
end
