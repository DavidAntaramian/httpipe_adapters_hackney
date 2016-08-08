defmodule HTTPlaster.Adapters.Hackney do
  @behaviour HTTPlaster.Adapter
  alias HTTPlaster.{Adapter, Request}


  @spec execute_request(Request.http_method, String.t, Request.body,
                        Request.headers, Adapter.options) :: Adapter.success | Adapter.failure
  def execute_request(method, url, body, headers, options) do
    req_body = request_body(body)
    req_headers = request_headers(headers)

    :hackney.request(method, url, req_headers, req_body, options)
    |> handle_response()
  end

  # HTTPlaster indicates an empty request body with
  # nil but Hackney expects an empty binary instead
  defp request_body(nil), do: ""
  defp request_body(b), do: b

  # The headers will be sent from HTTPlaster as a map,
  # but Hackney expects the headers to be a Keyword list
  defp request_headers(headers), do: Enum.map(headers, &(&1))

  defp handle_response({:ok, status_code, resp_headers, client_ref}) do
    case get_body(client_ref) do
      {:ok, body} -> {:ok, {status_code, resp_headers, body}}
      {:error, reason} -> {:error, reason}
    end
  end

  defp handle_response({:error, _} = error), do: error

  defp get_body(client_ref), do: :hackney.body(client_ref)
end
