class CoingeckosController < ApplicationController
  def coins_list
    render json: coingecko_client.coins_list
  end

  def exchanges
    render json: coingecko_client.exchanges
  end

  def exchange_tickers
    tickers_data = exchange_tickers_params[:data].each_with_object({}) do |item, memo|
      data_chunk = coingecko_client.exchange_tickers(item[:exchange_id], coin_ids: item[:coin_ids])
      memo[item[:exchange_id]] = data_chunk['tickers']
    end

    render json: tickers_data
  end

  private

  def exchange_tickers_params
    params.permit(data: %i[exchange_id coin_ids])
  end

  def coingecko_client
    @_coingecko_client ||= CoingeckoRuby::Client.new
  end
end
