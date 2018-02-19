defmodule ReduceTest do
  use ExUnit.Case, async: true

  test "get_suppliers when have 2 datasets returns the parsed data" do
    test_data = [
      {"supplier1", %{"abcd" => 300.2, "defg" => 403.22, "mnop" => 288.3}},
      {"supplier2", %{"abcd" => 299.9, "mnop" => 340.33}}
    ]

    assert Reduce.get_suppliers(test_data) == [
      %{id: "abcd", price: 299.9, supplier: "supplier2"},
      %{id: "defg", price: 403.22, supplier: "supplier1"},
      %{id: "mnop", price: 288.3, supplier: "supplier1"},
    ]
  end

  #test "get_suppliers returns all suppliers data" do
    #test_data = [
      #{"supplier1", %{"abcd" => 300.2, "defg" => 403.22, "mnop" => 288.3}},
      #{"supplier2", %{"abcd" => 299.9, "mnop" => 340.33}},
      #{"supplier3", %{"abcd" => 340.2, "defg" => 320.49, "mnop" => 317}}
    #]

    #assert Reduce.get_suppliers(test_data) == [
      #%{id: "abcd", price: 299.9, supplier: "supplier2"},
      #%{id: "defg", price: 403.22, supplier: "supplier1"},
      #%{id: "mnop", price: 288.3, supplier: "supplier1"},
    #]
  #end

  test "get_suppliers_x when have 3 datasets returns the parsed data" do
    test_data = [
      %{"abcd" => 300.2, "defg" => 403.22, "mnop" => 288.3},
      %{"abcd" => 299.9, "mnop" => 340.33},
      %{"abcd" => 340.2, "defg" => 320.49, "mnop" => 317},
      %{"abcd" => 1002, "defg" => 2231, "mnop" => 317}
    ]

    assert Reduce.get_suppliers_x(test_data) == %{
      "abcd" => 299.9,
      "defg" => 320.49,
      "mnop" => 288.3
    }
  end

  test "get_suppliers_y when have 5 datasets returns the parsed data" do
    test_data = [
      %{"abcd" => {"supplier1", 300.2}, "defg" => {"supplier1", 403.22}, "mnop" => {"supplier1", 288.3}},
      %{"abcd" => {"supplier2", 299.9}, "mnop" => {"supplier2", 340.33}},
      %{"abcd" => {"supplier3", 340.2}, "defg" => {"supplier3",  320.49}, "mnop" => {"supplier3", 317}},
      %{"abcd" => {"supplier4", 1002}, "defg" => {"supplier4", 12.5}, "mnop" => {"supplier4", 317}}
    ]

    assert Reduce.get_suppliers_y(test_data) == %{
      "abcd" => {"supplier2", 299.9},
      "defg" => {"supplier4", 12.5},
      "mnop" => {"supplier1", 288.3}
    }
  end
end

