class CreateCoinWidgets < ActiveRecord::Migration[7.0]
  def change
    create_table :coin_widgets do |t|
      t.references :cluster, foreign_key: true

      t.string :main_coin
      t.string :secd_coin
      t.text :amount, array: true, default: []
      t.text :invested, array: true, default: []
      t.string :change_up_to, default: 'off'
      t.string :change_down_to, default: 'off'
      t.text :notification

      t.timestamps
    end
  end
end
