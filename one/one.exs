defmodule Frequency do
  def analyze(lines, first_total \\ nil, sum \\ 0, subtotals \\ %{}) do
    {sum, twice, subtotals} = iterate_frequencies(lines, sum, subtotals)

    case twice do
      nil -> analyze(lines, first_total || sum, sum, subtotals)
      _   -> {first_total, twice}
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
            true  ->
              case Map.has_key?(subtotals, new_total) do
                false -> {nil, Map.put(subtotals, new_total, true)}
                true  -> {new_total, subtotals}
              end
          end
        {new_total, twice, subtotals}
      end
    )
  end
end

{sum, twice} =
  File.read("input.txt")
  |> elem(1)
  |> String.split
  |> Frequency.analyze

IO.puts("Sum: #{sum}")
IO.puts("Twice: #{twice}")
