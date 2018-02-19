defmodule SearchApi.Router do
  import SearchApi.Controller
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/suppliers", do: suppliers_handler(conn, fetch_query_params(conn).params)

  match _ do
    send_resp(conn, 404, "Not found.")
  end
end
