class AddViewOrderToClusters < ActiveRecord::Migration[7.0]
  def change
    add_column :clusters, :view_order, :integer
  end
end
