defmodule ExBinance.Rest.UserDataStream do
  alias ExBinance.Rest.HTTPClient

  # @receiving_window 1000

  @path "/fapi/v1/listenKey"

  def user_data_stream() do
    @path
    |> HTTPClient.post(%{})
    |> parse_response()
  end

  def update_listen_key() do
    @path
    |> HTTPClient.put(%{})
    |> parse_response()
  end

  def delete_listen_key() do
    @path
    |> HTTPClient.delete(%{})
    |> parse_response()
  end

  defp parse_response({:ok, response}) do
    {:ok, ExBinance.Responses.UserDataStream.new(response)}
  end

  defp parse_response({:error, {:binance_error, %{"code" => -2010, "msg" => msg}}}),
    do: {:error, {:insufficient_balance, msg}}

  defp parse_response({:error, _} = error), do: error
end
