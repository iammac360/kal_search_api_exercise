defmodule SearchApiTest do
  use ExUnit.Case

  doctest SearchApi

  @urls [
    {"supplier1", "https://api.myjson.com/bins/2tlb8"},
    {"supplier2", "https://api.myjson.com/bins/42lok"},
    {"supplier3", "https://api.myjson.com/bins/15ktg"}
  ]

  test "filter_supplier_url_list returns a list of tuple" do
    assert SearchApi.filter_supplier_url_list(["supplier1", "supplier3"]) == [
      {"supplier1", "https://api.myjson.com/bins/2tlb8"},
      {"supplier3", "https://api.myjson.com/bins/15ktg"}
    ]
  end

  test "filter_supplier_url_list(nil) returns all lists of urls" do
    assert SearchApi.filter_supplier_url_list([]) == @urls
  end

  test "filter_supplier_url_list([\"\"]) returns all lists of urls" do
    assert SearchApi.filter_supplier_url_list([""]) == @urls
  end

  test "filter_supplier_url_list([]) returns all lists of urls" do
    assert SearchApi.filter_supplier_url_list([]) == @urls
  end

  test "get_suppliers returns all suppliers data" do
    assert SearchApi.get_suppliers(@urls) == [
      %{id: "abcd", price: 300.2, supplier: "supplier1"},
      %{id: "defg", price: 403.22, supplier: "supplier1"},
      %{id: "mnop", price: 288.3, supplier: "supplier1"},
      %{id: "abcd", price: 299.9, supplier: "supplier2"},
      %{id: "mnop", price: 340.33, supplier: "supplier2"},
      %{id: "abcd", price: 340.2, supplier: "supplier3"},
      %{id: "defg", price: 320.49, supplier: "supplier3"},
      %{id: "mnop", price: 317.0, supplier: "supplier3"}
    ]
  end

  test "get_suppliers returns empty list if first argument is an empty list" do
    assert SearchApi.get_suppliers([]) == []
  end

  test "get_supplier returns a supplier data" do
    [url | _] = @urls #Get the first supplier

    assert SearchApi.get_supplier(url) == [
      %{id: "abcd", price: 300.2, supplier: "supplier1"},
      %{id: "defg", price: 403.22, supplier: "supplier1"},
      %{id: "mnop", price: 288.3, supplier: "supplier1"}
    ]
  end
end
