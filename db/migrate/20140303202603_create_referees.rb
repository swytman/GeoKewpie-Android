class CreateReferees < ActiveRecord::Migration
  def change
    create_table :referees do |t|
      t.string :name
      t.string :surname
      t.string :middlename
      t.string :status
      t.timestamps
    end
  end
end
