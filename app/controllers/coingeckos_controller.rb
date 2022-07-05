class CoingeckosController < ApplicationController
  def coins_list
    render json: coingecko_client.coins_list
  end

  def top_popular_coins
    render json: coingecko_client.markets('', vs_currency: 'usd')
  end

  def exchanges
    render json: coingecko_client.exchanges
  end

  def exchange_tickers
    tickers_data = exchange_tickers_params[:data].each_with_object({}) do |item, memo|
      data = coingecko_client.exchange_tickers(item[:exchange_id], coin_ids: item[:coin_ids])
      tickers_data = data['tickers']

      # next_page = 2 if tickers_data.size >= 100

      # while next_page > 0
      #   next_data = coingecko_client.exchange_tickers(item[:exchange_id], coin_ids: item[:coin_ids], page: page)
      #   tickers_data.concat(next_data['tickers'])

      #   next_page = next_data['tickers'].size >= 100 ? (next_page + 1) : 0
      # end
      # Temporary workaround
      if tickers_data.size >= 100
        next_data = coingecko_client.exchange_tickers(item[:exchange_id], coin_ids: item[:coin_ids], page: 2)
        tickers_data.concat(next_data['tickers'])
      end

      if tickers_data.size >= 200
        next_data = coingecko_client.exchange_tickers(item[:exchange_id], coin_ids: item[:coin_ids], page: 3)
        tickers_data.concat(next_data['tickers'])
      end

      memo[item[:exchange_id]] = tickers_data
    end

    render json: tickers_data
  end

  def coins_market_data
    render json: coingecko_client.markets(coins_markets_params[:coin_ids], vs_currency: 'usd')
  end

  private

  def exchange_tickers_params
    params.permit(data: %i[exchange_id coin_ids])
  end

  def coins_markets_params
    params.permit(:coin_ids)
  end

  def coingecko_client
    @_coingecko_client ||= CoingeckoRuby::Client.new
  end
end
