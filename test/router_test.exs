defmodule SearchApi.RouterTest do
  use ExUnit.Case
  use Plug.Test
  alias SearchApi.Router

  doctest SearchApi.Router

  test "GET /suppliers should return 400 when required params is not supplied" do
    response = conn(:get, "/suppliers") |> Router.call([])

    assert response.status == 400
  end

  test "GET /suppliers should return 200 and all the suppliers data when required params are present" do
    params = %{checkin: 1, checkout: 2, destination: 3, guests: 4}
    response = conn(:get, "/suppliers", params) |> Router.call([])

    assert response.status == 200

    assert Poison.decode!(response.resp_body) == [
      %{"id" => "mnop", "price" => 288.3, "supplier" => "supplier1"},
      %{"id" => "abcd", "price" => 299.9, "supplier" => "supplier2"},
      %{"id" => "defg", "price" => 320.49, "supplier" => "supplier3"},
    ]
  end

  test "GET /suppliers should return 200 and filtered suppliers when required params are present and suppliers param is passed" do
    params = %{checkin: 1, checkout: 2, destination: 3, guests: 4, suppliers: "supplier1,supplier3"}
    response = conn(:get, "/suppliers", params) |> Router.call([])

    assert response.status == 200

    assert Poison.decode!(response.resp_body) == [
      %{"id" => "mnop", "price" => 288.3, "supplier" => "supplier1"},
      %{"id" => "abcd", "price" => 300.2, "supplier" => "supplier1"},
      %{"id" => "defg", "price" => 320.49, "supplier" => "supplier3"},
    ]
  end

  test "GET /suppliers should return 200 and empty array when supplier params value does not exists" do
    params = %{checkin: 1, checkout: 2, destination: 3, guests: 4, suppliers: "nonexistingsupplier"}
    response = conn(:get, "/suppliers", params) |> Router.call([])

    assert response.status == 200

    assert Poison.decode!(response.resp_body) == []
  end
end
