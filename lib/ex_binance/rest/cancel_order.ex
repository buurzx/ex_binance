defmodule ExBinance.Rest.CancelOrder do
  alias ExBinance.Rest.HTTPClient
  alias ExBinance.{Timestamp}

  @type symbol :: String.t()
  @type order_id :: String.t()
  @type credentials :: ExBinance.Credentials.t()
  @type ok_response :: ExBinance.Responses.CancelOrder.t()
  @type error_msg :: String.t()
  @type error_reason :: {:not_found, error_msg} | ExBinance.Rest.HTTPClient.shared_errors()

  @receiving_window 1000

  def cancel_order_by_order_id(symbol, order_id, futures \\ true) do
    params = %{
      symbol: symbol,
      orderId: order_id,
      timestamp: Timestamp.now(),
      recvWindow: @receiving_window
    }

    path(futures)
    |> HTTPClient.delete(params)
    |> parse_response()
  end

  defp parse_response({:ok, response}), do: {:ok, ExBinance.Responses.CancelOrder.new(response)}

  defp parse_response({:error, {:binance_error, %{"code" => -2011, "msg" => msg}}}),
    do: {:error, {:not_found, msg}}

  defp parse_response({:error, _} = error), do: error

  defp path(futures) do
    if futures, do: "/fapi/v1/order", else: "/api/v3/order"
  end
end
