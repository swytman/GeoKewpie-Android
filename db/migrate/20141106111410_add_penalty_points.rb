class AddPenaltyPoints < ActiveRecord::Migration
  def change
    add_column :teams, :penalty_points, :integer, default: 0
    add_column :posts, :champ_id, :integer

  end
end
