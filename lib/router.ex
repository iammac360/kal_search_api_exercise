defmodule SearchApi.Router do
  import Plug.Conn
  import SearchApi
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/suppliers", do: suppliers_handler(conn, fetch_query_params(conn).params)

  match _ do
    send_resp(conn, 404, "Not found.")
  end

  def suppliers_handler(conn, %{
    "checkin" => checkin,
    "checkout" => checkout,
    "destination" => destination,
    "guests" => guests
  } = params) do

    suppliers = params["suppliers"] || "" # Optional param
    key = "#{checkin}:#{checkout}:#{destination}:#{guests}"
    
    data = fetch_suppliers_data(suppliers, key)

    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, Poison.encode!(data))
  end
  def suppliers_handler(conn, _) do
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
