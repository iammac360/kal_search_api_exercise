defmodule SearchApi do
  @moduledoc """
  Documentation for SearchApi.
  """

  @urls [
    {"supplier1", "https://api.myjson.com/bins/2tlb8"},
    {"supplier2", "https://api.myjson.com/bins/42lok"},
    {"supplier3", "https://api.myjson.com/bins/15ktg"}
  ]

  @timeout 145000

  def filter_supplier_url_list(nil), do: @urls
  def filter_supplier_url_list([]), do: @urls
  def filter_supplier_url_list([""]), do: @urls
  def filter_supplier_url_list(suppliers) do
    Enum.filter(@urls, fn({s, _}) -> Enum.member?(suppliers, s) end)
  end

  def get_suppliers(urls) do
    # Make http request from urls concurrently and asynchronously
    Enum.map(urls, fn(url) -> Task.async(fn -> get_supplier(url) end) end)
    |> Enum.map(fn(task) -> Task.await(task, @timeout) end)
    |> List.flatten
  end

  def get_supplier({supplier, url}) do
     %HTTPoison.Response{body: body, status_code: status_code} = HTTPoison.get!(url)

    case status_code do
      200 -> 
        body
        |> Poison.decode!
        |> Map.to_list 
        |> Enum.map(fn({id, price}) -> %{id: id, price: price, supplier: supplier} end)

      _ ->
        {:error, "Error #{status_code}"}
    end
  end
end
