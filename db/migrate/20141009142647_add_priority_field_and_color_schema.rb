class AddPriorityFieldAndColorSchema < ActiveRecord::Migration
  def change
    add_column :champs, :order_priority, :integer, default: 0
    add_column :champs, :label_css_schema, :string
  end
end
