defmodule ExBinance.Candlestick do
  # [
  #   1499040000000,      // Open time
  #   "0.01634790",       // Open
  #   "0.80000000",       // High
  #   "0.01575800",       // Low
  #   "0.01577100",       // Close
  #   "148976.11427815",  // Volume
  #   1499644799999,      // Close time
  #   "2434.19055334",    // Quote asset volume
  #   308,                // Number of trades
  #   "1756.87402397",    // Taker buy base asset volume
  #   "28.46694368",      // Taker buy quote asset volume
  #   "17928899.62484339" // Ignore.
  # ]

  defstruct [:open_time, :open, :high, :low, :close, :volume]

  def new(list) when is_list(list) do
    {[open_time, open, high, low, close, volume], _} = Enum.split(list, 6)

    %__MODULE__{
      open_time: open_time,
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume
    }
  end

  def new([]),
    do: %__MODULE__{}
end
