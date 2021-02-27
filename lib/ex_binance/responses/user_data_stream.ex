defmodule ExBinance.Responses.UserDataStream do
  @moduledoc """
  Struct for representing a result row as returned by /fapi/v1/listenKey

  ```
  defstruct [
    :listen_key
  ]
  ```
  """

  defstruct [
    :listen_key
  ]

  use ExConstructor
end
