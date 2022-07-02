class AddQuoteCurrencyIdToCoinWidgets < ActiveRecord::Migration[7.0]
  def change
    add_column :coin_widgets, :quote_currency_id, :string
  end
end
