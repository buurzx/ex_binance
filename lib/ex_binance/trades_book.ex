defmodule ExBinance.TradesBook do
  @moduledoc """
  Struct for representing the result returned by /fapi/v1/trades
  """

  defstruct [:id, :price, :qty, :quoteQty, :time, :isBuyerMaker]

  use ExConstructor
end
