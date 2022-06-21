class AddBaseCurrencyIdToCoinWidgets < ActiveRecord::Migration[7.0]
  def change
    add_column :coin_widgets, :base_currency_id, :string
  end
end
