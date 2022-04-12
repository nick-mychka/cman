class CoingeckosController < ApplicationController

  def exchanges
    render json: coingecko_client.exchanges
  end

  private

  def coingecko_client
    @_coingecko_client ||= CoingeckoRuby::Client.new
  end
end
