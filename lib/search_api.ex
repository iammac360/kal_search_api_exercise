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
    |> Enum.reduce(nil, &handle_task/2)
    |> map_response
  end

  def get_supplier({supplier, url}) do
    case Cachex.get(@cache, supplier) do
      {:missing, nil} ->
        IO.puts "Supplier: #{supplier} is not yet cached fetching records from external source"
        to_be_cached = get_supplier_from_api({supplier, url})
        Cachex.set(@cache, supplier, to_be_cached, [ttl: :timer.seconds(@ttl_in_sec)])

        to_be_cached
      {:ok, cached_data} ->
        IO.puts "Supplier: #{supplier} found. Retrieving Cache"
        cached_data
    end
  end

  def get_supplier_from_api({supplier, url}) do
     %HTTPoison.Response{body: body, status_code: status_code} = HTTPoison.get!(url)

    case status_code do
      200 -> for {k, v} <- Poison.decode!(body), into: %{}, do: {k, {supplier, v}}

      _ ->
        {:error, "Error #{status_code}"}
    end
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

  defp handle_task(task, nil), do: Task.await(task, @timeout)
  defp handle_task(task, acc) do
    data = Task.await(task, @timeout)
    
    for {k, {s1, p1}} <- acc, into: %{} do
      case data[k] do
        nil -> {k, {s1, p1}}

        {s2, p2} ->
          # Evaluate lowest price
          if p1 < p2, do: {k, {s1, p1}}, else: {k, {s2, p2}}
      end
    end
  end

  defp map_response(data) do
    case(data) do
      nil -> []
      data ->
        for {id, {supplier, price}} <- data, do: %{id: id, price: price, supplier: supplier}
    end
  end
end
