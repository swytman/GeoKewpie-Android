class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :surname
      t.string :middlename
      t.integer :team_id
      t.string :phone
      t.date :birthdate
      t.date :drafted
      t.integer :number
      t.timestamps
    end
  end
end
