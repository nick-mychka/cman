class ClusterBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :view_order

  association :coin_widgets, blueprint: CoinWidgetBlueprint
end
