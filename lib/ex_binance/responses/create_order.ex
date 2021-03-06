defmodule ExBinance.Responses.CreateOrder do
  defstruct ~w(
    client_order_id
    executed_qty
    order_id
    orig_qty
    price
    side
    status
    symbol
    time_in_force
    transact_time
    type
    fills
  )a

  use ExConstructor
end

# {
#   "avgPrice": "0.00000",
#   "clientOrderId": "abc",
#   "cumQuote": "0",
#   "executedQty": "0",
#   "orderId": 1917641,
#   "origQty": "0.40",
#   "origType": "TRAILING_STOP_MARKET",
#   "price": "0",
#   "reduceOnly": false,
#   "side": "BUY",
#   "positionSide": "SHORT",
#   "status": "NEW",
#   "stopPrice": "9300",                // please ignore when order type is TRAILING_STOP_MARKET
#   "closePosition": false,   // if Close-All
#   "symbol": "BTCUSDT",
#   "time": 1579276756075,              // order time
#   "timeInForce": "GTC",
#   "type": "TRAILING_STOP_MARKET",
#   "activatePrice": "9020",            // activation price, only return with TRAILING_STOP_MARKET order
#   "priceRate": "0.3",                 // callback rate, only return with TRAILING_STOP_MARKET order
#   "updateTime": 1579276756075,        // update time
#   "workingType": "CONTRACT_PRICE",
#   "priceProtect": false            // if conditional order trigger is protected
# }
