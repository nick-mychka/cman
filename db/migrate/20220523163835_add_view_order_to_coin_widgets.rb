class AddViewOrderToCoinWidgets < ActiveRecord::Migration[7.0]
  def change
    add_column :coin_widgets, :view_order, :integer
  end
end
