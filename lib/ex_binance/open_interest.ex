defmodule ExBinance.OpenInterest do
  @moduledoc """
  Struct for representing the result returned by /fapi/v1/openInterest
  """

  defstruct [:openInterest, :symbol, :time]

  use ExConstructor
end
