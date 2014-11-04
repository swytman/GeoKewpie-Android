class AddYCardLimit < ActiveRecord::Migration
  def change
    add_column :champs, :y_cards_limit, :integer, default: 3
  end
end
