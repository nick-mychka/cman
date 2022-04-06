class CoinWidgetsController < ApplicationController
  before_action :authorized

  def index
    render json: CoinWidgetBlueprint.render(current_cluster.coin_widgets), status: :ok
  rescue
    render json: "Not Found", status: :not_found
  end

  def create
    coin_widget = current_cluster.coin_widgets.new(coin_widget_params)
    coin_widget.save!
    render json: CoinWidgetBlueprint.render(coin_widget), status: :created
  rescue
    render json: coin_widget, status: :unprocessable_entity
  end

  def update
    current_coin_widget.update!(coin_widget_params)
    render json: CoinWidgetBlueprint.render(current_coin_widget), status: :ok
  rescue
    render json: current_coin_widget, status: :unprocessable_entity
  end

  def destroy
    current_coin_widget.destroy
    head :no_content
  end

private
  def coin_widget_params
    params.permit(
      :base_currency,
      :quote_currency,
      :change_up_to,
      :change_down_to,
      :exchange_id,
      { trade_history: [:amount, :invested] },
      :notification
    ).tap do |new_params|
      new_params[:trade_history] = new_params[:trade_history].map(&:to_json)
    end
  end

  def current_cluster
    @_current_cluster ||= current_user.clusters.find(params[:cluster_id])
  end

  def current_coin_widget
    @_current_coin_widget ||= current_cluster.coin_widgets.find(params[:id])
  end
end
