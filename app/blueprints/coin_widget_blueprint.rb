class CoinWidgetBlueprint < Blueprinter::Base
  identifier :id

  fields :base_currency, :quote_currency, :base_currency_id, :change_up_to, :change_down_to, :exchange_id, :trade_history, :notification, :view_order

  field :trade_history  do |coin_widget|
    coin_widget.trade_history.map { |deal| JSON.parse deal }
  end

  field :amount do |coin_widget|
    coin_widget.trade_history.sum { |deal| JSON.parse(deal)['amount'].to_f }
  end

  field :invested do |coin_widget|
    coin_widget.trade_history.sum { |deal| JSON.parse(deal)['invested'].to_f }
  end
end
