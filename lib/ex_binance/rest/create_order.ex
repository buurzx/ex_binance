defmodule ExBinance.Rest.CreateOrder do
  alias ExBinance.Rest.HTTPClient
  alias ExBinance.Timestamp

  @receiving_window 1000

  def create_order(
        symbol,
        side,
        type,
        quantity,
        price,
        time_in_force,
        credentials,
        futures \\ true
      ) do
    params = %{
      symbol: symbol,
      side: side,
      type: type,
      quantity: quantity,
      price: price,
      timeInForce: time_in_force,
      timestamp: Timestamp.now(),
      recvWindow: @receiving_window
    }

    path(futures)
    |> HTTPClient.post(params, credentials)
    |> parse_response()
  end

  defp parse_response({:ok, response}), do: {:ok, ExBinance.Responses.CreateOrder.new(response)}

  defp parse_response({:error, {:binance_error, %{"code" => -2010, "msg" => msg}}}),
    do: {:error, {:insufficient_balance, msg}}

  defp parse_response({:error, _} = error), do: error

  defp path(futures) do
    if futures, do: "/fapi/v1/order", else: "/api/v3/order"
  end
end
