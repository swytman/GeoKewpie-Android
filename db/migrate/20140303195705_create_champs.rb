class CreateChamps < ActiveRecord::Migration
  def change
    create_table :champs do |t|
      t.string :title
      t.string :description
      t.string :type
      t.date :start_date
      t.date :end_date
      t.string :status
      t.integer :parent_champ_id

      t.timestamps
    end
  end
end
