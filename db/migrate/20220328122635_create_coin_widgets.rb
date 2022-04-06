class CreateCoinWidgets < ActiveRecord::Migration[7.0]
  def change
    create_table :coin_widgets do |t|
      t.references :cluster, foreign_key: true

      t.string :base_currency
      t.string :quote_currency
      t.string :change_up_to, default: 'off'
      t.string :change_down_to, default: 'off'
      t.string :exchange_id, default: 'binance'
      t.text :trade_history, array: true, default: []
      t.text :notification

      t.timestamps
    end
  end
end
