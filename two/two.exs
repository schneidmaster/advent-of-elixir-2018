defmodule Scanner do
  def checksum(lines) do
    {num_2x, num_3x} =
      lines
      |> Enum.reduce(
        {0, 0},
        fn id, {num_2x, num_3x} ->
          id
          |> String.graphemes
          |> Enum.reduce(
            %{},
            fn char, acc ->
              Map.put(acc, char, (acc[char] || 0) + 1)
            end
          )
          |> Enum.reduce(
            {false, false},
            fn {_, val}, {has_2x, has_3x} ->
              {
                has_2x || val == 2,
                has_3x || val == 3
              }
            end
          )
          |> case do
            {true, true}   -> {num_2x + 1, num_3x + 1}
            {true, false}  -> {num_2x + 1, num_3x}
            {false, true}  -> {num_2x, num_3x + 1}
            {false, false} -> {num_2x, num_3x}
          end
        end
      )

    num_2x * num_3x
  end

  def match_diff(lines) do
    lines = Enum.map(lines, fn line -> String.graphemes(line) end)
    lines
    |> Enum.find_value(
      fn id ->
        match =
          lines
          |> Enum.find(
            fn second_id ->
              id
              |> Enum.with_index
              |> Enum.reduce(
                {false, 0},
                fn {char, idx}, {exactly_one, count} ->
                  case Enum.at(second_id, idx) == char do
                    true  -> {exactly_one, count}
                    false ->
                      case count do
                        0 -> {true, count + 1}
                        _ -> {false, count + 1}
                      end
                  end
                end
              )
              |> elem(0)
            end
          )

        case match do
          nil -> nil
          second_id ->
            id
              |> Enum.with_index
              |> Enum.filter(
                fn {char, idx} ->
                  char == Enum.at(second_id, idx)
                end
              )
              |> Enum.map(fn {char, _} -> char end)
              |> Enum.join
        end
      end
    )
  end
end

lines =
  File.read("input.txt")
  |> elem(1)
  |> String.split

IO.puts("Checksum: #{Scanner.checksum(lines)}")
IO.puts("Match diff: #{Scanner.match_diff(lines)}")
