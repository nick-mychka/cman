class CoingeckosController < ApplicationController
  def coins_list
    render json: coingecko_client.coins_list
  end

  def exchanges
    render json: coingecko_client.exchanges
  end

  def exchange_tickers
    tickers_data = exchange_tickers_params[:data].each_with_object({}) do |item, memo|
      data = coingecko_client.exchange_tickers(item[:exchange_id], coin_ids: item[:coin_ids])
      tickers_data = data['tickers']

      if tickers_data.size >= 100
        second_page_data = coingecko_client.exchange_tickers(item[:exchange_id], coin_ids: item[:coin_ids], page: 2)
        tickers_data.concat(second_page_data['tickers'])
      end

      memo[item[:exchange_id]] = tickers_data
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
