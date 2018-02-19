defmodule SearchApi.Controller do
  import Plug.Conn
  import SearchApi

  def suppliers_handler(conn, %{
    "checkin" => checkin,
    "checkout" => checkout,
    "destination" => destination,
    "guests" => guests
  } = params) do

    suppliers = params["suppliers"] || "" # Optional param
    key = "#{checkin}:#{checkout}:#{destination}:#{guests}:#{suppliers}"
    
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
    |> send_resp(400, Poison.encode!(%{
      message: "Bad Request",
      error: error
    }))
  end
end
