defmodule ExBinance.Rest.HTTPClient do
  alias ExBinance.Credentials

  @type credentials :: ExBinance.Credentials.t()
  @type path :: String.t()
  @type header :: {key :: String.t(), value :: String.t()}
  @type config_error :: {:config_missing, String.t()}
  @type shared_errors ::
          :timeout
          | :connect_timeout
          | {:http_error, any}
          | {:decode_error, Jason.DecodeError.t()}
          | :bad_symbol
          | :receive_window
          | {:binance_error, map}

  @receive_window 5000
  @api_key_header "X-MBX-APIKEY"

  @spec get(path, map, [header]) :: {:ok, any} | {:error, shared_errors}
  def get(path, params, headers \\ []) do
    query = URI.encode_query(params)
    uri = %URI{path: path, query: query} |> URI.to_string()

    [endpoint(), uri]
    |> Path.join()
    |> HTTPoison.get(headers)
    |> parse_response
  end

  @spec get_auth(path, map) :: {:ok, any} | {:error, shared_errors}
  def get_auth(path, params) do
    params =
      params
      |> Map.merge(%{
        timestamp: DateTime.utc_now() |> DateTime.to_unix(:millisecond),
        recvWindow: @receive_window
      })

    query = URI.encode_query(params)
    signature = sign(credentials().secret_key, query)
    signed_params = params |> Map.put(:signature, signature)
    headers = [{@api_key_header, credentials().api_key}]

    get(path, signed_params, headers)
  end

  @spec post(String.t(), map) :: {:ok, any} | {:error, shared_errors}
  def post(path, params) do
    argument_string =
      params
      |> Map.to_list()
      |> Enum.map(fn x -> Tuple.to_list(x) |> Enum.join("=") end)
      |> Enum.join("&")

    signature = sign(credentials().secret_key, argument_string)

    body =
      [argument_string, "signature=#{signature}"]
      |> Enum.filter(&(&1 != ""))
      |> Enum.join("&")

    headers = [
      {@api_key_header, credentials().api_key},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    "#{endpoint()}#{path}"
    |> HTTPoison.post(body, headers)
    |> parse_response()
  end

  @spec put(String.t(), map) :: {:ok, any} | {:error, shared_errors}
  def put(path, params) do
    argument_string =
      params
      |> Map.to_list()
      |> Enum.map(fn x -> Tuple.to_list(x) |> Enum.join("=") end)
      |> Enum.join("&")

    signature = sign(credentials().secret_key, argument_string)

    body =
      [argument_string, "signature=#{signature}"]
      |> Enum.filter(&(&1 != ""))
      |> Enum.join("&")

    headers = [
      {@api_key_header, credentials().api_key},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    IO.inspect(body, label: "body")

    "#{endpoint()}#{path}"
    |> HTTPoison.put(body, headers)
    |> parse_response()
  end

  @spec delete(String.t(), map) :: {:ok, any} | {:error, shared_errors}
  def delete(path, params) do
    :delete
    |> request(path, params)
    |> parse_response()
  end

  defp request(method, path, params) do
    argument_string =
      params
      |> Map.to_list()
      |> Enum.map(fn x -> Tuple.to_list(x) |> Enum.join("=") end)
      |> Enum.join("&")

    signature = sign(credentials().secret_key, argument_string)
    body = "#{argument_string}&signature=#{signature}"

    headers = [
      {@api_key_header, credentials().api_key},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    HTTPoison.request(
      method,
      "#{endpoint()}#{path}",
      body,
      headers
    )
  end

  defp sign(secret_key, argument_string),
    do: :sha256 |> :crypto.hmac(secret_key, argument_string) |> Base.encode16()

  defp parse_response({:ok, response}) do
    response.body
    |> Jason.decode()
    |> parse_response_body
  end

  defp parse_response({:error, %HTTPoison.Error{id: nil, reason: :timeout}}),
    do: {:error, :timeout}

  defp parse_response({:error, %HTTPoison.Error{id: nil, reason: :connect_timeout}}),
    do: {:error, :connect_timeout}

  defp parse_response({:error, err}), do: {:error, {:http_error, err}}

  defp parse_response_body({:ok, %{"code" => -1121}}), do: {:error, :bad_symbol}
  defp parse_response_body({:ok, %{"code" => -1021}}), do: {:error, :receive_window}
  defp parse_response_body({:ok, %{"code" => _} = reason}), do: {:error, {:binance_error, reason}}
  defp parse_response_body({:ok, _} = result), do: result
  defp parse_response_body({:error, err}), do: {:error, {:decode_error, err}}

  def endpoint, do: "https://#{domain()}"
  def domain, do: Application.get_env(:ex_binance, :domain, "fapi.binance.com")

  def credentials do
    Credentials.fetch()
  end
end
