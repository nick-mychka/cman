class CoinWidgetBlueprint < Blueprinter::Base
  identifier :id

  fields :main_coin, :secd_coin, :amount, :invested, :change_up_to, :change_down_to, :notification
end
