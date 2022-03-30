class CoinWidgetBlueprint < Blueprinter::Base
  identifier :id

  fields :base_currency, :quote_currency, :investment_list, :change_up_to, :change_down_to, :notification

  field :amount do |coin_widget|
    coin_widget.investment_list.sum { |b| b.amount.to_i }
  end

  field :invested do |coin_widget|
    coin_widget.investment_list.sum { |b| b.invested.to_i }
  end
end
