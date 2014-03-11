class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string   "title"
      t.string   "description"
      t.string   "stage_type"
      t.date     "start_date"
      t.date     "end_date"
      t.string   "status"
      t.integer  "champ_id"
      t.timestamps
    end
    remove_column :champs, :parent_champ_id
  end
end
