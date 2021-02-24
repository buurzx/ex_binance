defmodule ExBinance.LongShortPositionsRaito do
  @moduledoc """
  Struct for representing the result returned by /fapi/v1/openInterest
  """

  defstruct [:longShortRatio, :longAccount, :shortAccount, :symbol, :timestamp]

  use ExConstructor
end
