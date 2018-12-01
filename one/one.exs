defmodule Frequency do
  def reduce(lines) do
    lines
    |> Enum.reduce(
      0,
      fn x, acc ->
        num = x |> Integer.parse |> elem(0)
        acc + num
      end
    )
  end

  def find_repeat(lines, sum \\ 0, subtotals \\ %{}) do
    {sum, twice, subtotals} = iterate_frequencies(lines, sum, subtotals)

    case twice do
      nil -> find_repeat(lines, sum, subtotals)
      _   -> twice
    end
  end

  def iterate_frequencies(lines, sum, subtotals) do
    lines
    |> Enum.reduce(
      {sum, nil, subtotals},
      fn x, {subtotal, twice, subtotals} ->
        num = x |> Integer.parse |> elem(0)
        new_total = subtotal + num
        {twice, subtotals} =
          case twice == nil do
            false -> {twice, subtotals}
            true ->
              case Map.has_key?(subtotals, new_total) do
                false -> {nil, Map.put(subtotals, new_total, true)}
                true -> {new_total, subtotals}
              end
          end
        {new_total, twice, subtotals}
      end
    )
  end
end

lines =
  File.read("input.txt")
  |> elem(1)
  |> String.split

IO.puts("Sum: #{Frequency.reduce(lines)}")
IO.puts("Twice: #{Frequency.find_repeat(lines)}")
