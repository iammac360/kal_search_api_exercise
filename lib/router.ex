defmodule SearchApi.Router do
  import Plug.Conn
  import SearchApi
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/suppliers", do: foo(conn, fetch_query_params(conn).params)

  match _ do
    send_resp(conn, 404, "Not found.")
  end

  def foo(conn, %{
    "checkin" => checkin,
    "checkout" => checkout,
    "destination" => destination,
    "guests" => guests
  } = params) do
    suppliers = params["suppliers"] || "" # Optional param
    cache_key = "#{checkin}:#{checkout}:#{destination}:#{guests}"

    data = String.split(suppliers, ",")
    |> filter_supplier_url_list
    |> get_suppliers
    |> Poison.encode!

    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, data)
  end
  def foo(conn, _) do
    error = "Required Fields are missing. \
      Please check if you have checkin, checkout, \
      destination and guests on your query params"

    conn
    |> put_resp_content_type("text/json")
    |> send_resp(404, Poison.encode!(%{
      error: error
    }))
  end
end
