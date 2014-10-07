class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :key
      t.string :title
    end
    create_join_table :users, :groups

  end
end
