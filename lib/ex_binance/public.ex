defmodule ExBinance.Public do
  import ExBinance.Rest.HTTPClient, only: [get: 2]

  def ping, do: get("/api/v1/ping", %{})

  def server_time do
    with {:ok, %{"serverTime" => time}} <- get("/api/v1/time", %{}) do
      {:ok, time}
    end
  end

  def exchange_info do
    with {:ok, data} <- get("/fapi/v1/exchangeInfo", %{}) do
      {:ok, ExBinance.ExchangeInfo.new(data)}
    end
  end

  def all_prices do
    with {:ok, data} <- get("/api/v1/ticker/allPrices", %{}) do
      {:ok, Enum.map(data, &ExBinance.SymbolPrice.new(&1))}
    end
  end

  def depth(symbol, limit) do
    with {:ok, data} <- get("/api/v1/depth", %{symbol: symbol, limit: limit}) do
      {:ok, ExBinance.OrderBook.new(data)}
    end
  end

  def recent_trades(symbol, limit) do
    with {:ok, data} <- get("/fapi/v1/trades", %{symbol: symbol, limit: limit}) do
      {:ok, Enum.map(data, &ExBinance.TradesBook.new/1)}
    end
  end

  def historical_trades(symbol, limit, from_id) do
    with {:ok, data} <-
           get("/fapi/v1/historicalTrades", %{symbol: symbol, limit: limit, from_id: from_id}) do
      {:ok, Enum.map(data, &ExBinance.TradesBook.new/1)}
    end
  end

  def open_interest(symbol) do
    with {:ok, data} <-
           get("/fapi/v1/openInterest", %{symbol: symbol}) do
      {:ok, ExBinance.OpenInterest.new(data)}
    end
  end

  def long_short_position_ratio(symbol, period, limit) do
    with {:ok, data} <-
           get("/futures/data/globalLongShortAccountRatio", %{
             symbol: symbol,
             period: period,
             limit: limit
           }) do
      {:ok, Enum.map(data, &ExBinance.LongShortPositionsRaito.new/1)}
    end
  end

  def candlesticks(symbol, interval, limit \\ 500, start_time \\ nil, end_time \\ nil) do
    with {:ok, data} <-
           get("/fapi/v1/klines", %{
             symbol: symbol,
             interval: interval,
             start_time: start_time,
             end_time: end_time,
             limit: limit
           }) do
      {:ok, Enum.map(data, &ExBinance.Candlestick.new/1)}
    end
  end
end
