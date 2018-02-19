defmodule Reduce do
  # SOME GIBERRISH CODES 
  # FOR TESTING PURPOSES ONLY
  # check tests @ test/reduce_test.exs
  def get_suppliers(data) do
    Enum.reduce(data, &mold_data/2)
  end

  def mold_data(data, acc) do
    {s1, m1} = acc
    {s2, m2} = data
    for {k, v} <- m1, %{} do
      if v < m2[k] do
        %{id: k, price: v, supplier: s1}
      else
        %{id: k, price: m2[k], supplier: s2}
      end
    end
  end

  def get_suppliers_x(data) do
    Enum.reduce(data, &mold_data_x/2)
  end

  def mold_data_x(data, acc) do
    for {k, v} <- acc, into: %{} do
      if v < data[k] do
        {k, v}
      else
        {k, data[k]}
      end
    end
  end

  def get_suppliers_y(data) do
    Enum.reduce(data, &mold_data_y/2)
  end

  def mold_data_y(data, acc) do
    for {k, {s1, p1}} <- acc, into: %{} do
      case data[k] do
        nil -> {k, {s1, p1}}

        {s2, p2} ->
          if p1 < p2, do: {k, {s1, p1}}, else: {k, {s2, p2}}
      end
    end
  end
end
