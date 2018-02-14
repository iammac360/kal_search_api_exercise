defmodule SearchApi do
  @moduledoc """
  Documentation for SearchApi.
  """

  @urls [
    {"supplier1", "https://api.myjson.com/bins/2tlb8"},
    {"supplier2", "https://api.myjson.com/bins/42lok"},
    {"supplier3", "https://api.myjson.com/bins/15ktg"}
  ]

  @cache :search_api
  @timeout 145_000
  @ttl_in_sec 300 # 5 minutes

  def filter_supplier_url_list(nil), do: @urls
  def filter_supplier_url_list([]), do: @urls
  def filter_supplier_url_list([""]), do: @urls
  def filter_supplier_url_list(suppliers) do
    Enum.filter(@urls, fn({s, _}) -> Enum.member?(suppliers, s) end)
  end

  def get_suppliers(urls) do
    # Make http request from urls concurrently and asynchronously
    urls 
    |> Enum.map(fn(url) -> Task.async(fn -> get_supplier(url) end) end)
    |> Enum.map(fn(task) -> Task.await(task, @timeout) end)
    |> List.flatten
    |> filter_lower_rates
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

  def filter_lower_rates(data) do
    data 
    |> Enum.sort_by(fn %{price: price} -> price end) # Sort by price from lowest to highest
    |> Enum.uniq_by(fn %{id: id} -> id end) # Remove duplicate ids
  end

  def fetch_suppliers_data(suppliers, key) do
    case Cachex.get(@cache, key) do
      {:missing, nil} -> 
        IO.puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        IO.puts "#{key} is not yet cached fetching records from external source"
        IO.puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

        to_be_cached = suppliers
        |> String.split(",")
        |> filter_supplier_url_list
        |> get_suppliers

        Cachex.set(@cache, key, to_be_cached, [ttl: :timer.seconds(@ttl_in_sec)])

        to_be_cached

      {:ok, cached_data} -> 
        IO.puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        IO.puts "#{key} found. Retrieving Cache"
        IO.puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

        cached_data
    end
  end
end
