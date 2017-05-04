defmodule HTTPipe.Adapters.Hackney do
  @moduledoc """
  Adapter for HTTPipe that calls out to hackney
  """

  @behaviour HTTPipe.Adapter

  alias HTTPipe.{Adapter, Request}
  alias __MODULE__.{RequestError, UnexpectedCloseError, CouldNotFetchBodyError}

  @doc """
  Executes the given request via Hackney. See the HTTPipe adapter documentation
  for more details.
  """
  @spec execute_request(Request.http_method, String.t, Request.body,
                        Request.headers, Adapter.options) :: Adapter.success
                                                           | Adapter.failure
  def execute_request(method, url, body, headers, options) do
    req_headers = request_headers(headers)

    :hackney.request(method, url, req_headers, body, options)
    |> handle_response()
  end

  # The headers will be sent from HTTPipe as a map,
  # but Hackney expects the headers to be a Keyword list
  defp request_headers(headers) do
    Enum.map(headers, &(&1))
  end

  defp handle_response({:ok, status_code, resp_headers}) do
    headers = process_response_headers(resp_headers)
    {:ok, {status_code, headers, :nil}}
  end
  defp handle_response({:ok, status_code, resp_headers, client_ref}) do
    case get_body(client_ref) do
      {:ok, body} ->
        headers = process_response_headers(resp_headers)
        {:ok, {status_code, headers, body}}
      {:error, reason} ->
        error = CouldNotFetchBodyError.exception(reason)
        {:error, error}
    end
  end

  defp handle_response({:error, {:closed, _}}) do
    error = UnexpectedCloseError.exception(nil)
    {:error, error}
  end

  defp handle_response({:error, reason}) do
    error = RequestError.exception(reason)
    {:error, error}
  end

  defp get_body(client_ref) do
    :hackney.body(client_ref)
  end
  
  defp process_response_headers(resp_headers) do
    Enum.reduce(resp_headers, %{}, fn {header, value}, headers ->
      name = String.downcase(header)
      Map.put(headers, name, value)
    end)
  end

  defmodule RequestError do
    defexception [:message]

    def exception(reason) do
      message = """
      Hackney encountered an error while attempting to communicate with
      the server. The reason given was:

      #{reason}
      """

      %__MODULE__{message: message}
    end
  end

  defmodule UnexpectedCloseError do
    defexception message: """
    Hackney was expecting the server to respond with more data, but
    the connection was closed.
    """
  end

  defmodule CouldNotFetchBodyError do
    defexception [:message]

    def exception(reason) do
      message = """
      Hackney could not fetch the body for the request. The reason
      given was:

      #{reason}
      """

      %__MODULE__{message: message}
    end
  end
end
