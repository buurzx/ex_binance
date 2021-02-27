defmodule ExBinance.Private do
  import ExBinance.Rest.HTTPClient, only: [get_auth: 2]

  @type credentials :: ExBinance.Credentials.t()
  @type shared_errors :: ExBinance.Rest.HTTPClient.shared_errors()

  @spec account(credentials) :: {:ok, term} | {:error, shared_errors}
  def account(futures \\ true) do
    with {:ok, data} <- get_auth(path(futures), %{}) do
      {:ok, ExBinance.Account.new(data)}
    end
  end

  defdelegate create_order(
                symbol,
                side,
                type,
                quantity,
                price,
                time_in_force,
                futures \\ true
              ),
              to: ExBinance.Rest.CreateOrder

  defdelegate cancel_order_by_order_id(
                symbol,
                order_id,
                futures \\ true
              ),
              to: ExBinance.Rest.CancelOrder

  defdelegate cancel_all_orders(symbol, futures), to: ExBinance.Rest.CancelAllOrders

  defdelegate user_data_stream(), to: ExBinance.Rest.UserDataStream
  defdelegate update_listen_key(), to: ExBinance.Rest.UserDataStream

  defdelegate get_order(
                symbol,
                timestamp,
                order_id
              ),
              to: ExBinance.Rest.Order

  defp path(futures) do
    if futures, do: "/fapi/v2/account", else: "/api/v3/account"
  end
end
