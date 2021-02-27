defmodule ExBinance.Rest.Order do
  alias ExBinance.Rest.HTTPClient

  def get_order(
        symbol,
        timestamp,
        order_id,
        futures \\ true
      ) do
    params = %{
      symbol: symbol,
      order_id: order_id,
      timestamp: timestamp
    }

    path(futures)
    |> HTTPClient.get(params)
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
