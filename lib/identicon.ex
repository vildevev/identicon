defmodule Identicon do
  
  def main(input) do
    # First object given to pipe operator will be passed down as first argument.
    input 
    |> hash_input
    |> pick_color
  end

  def pick_color(image) do 
    # Use pattern matching to set the list equal to the hex_list variable.
    # Have to perfectly describe element on the right for pattern matching to work unless using pipe and '_tail'.
    # Only care about the first three elements
    %Identicon.Image{hex: [r, g, b | _tail]} = image 

    [r, g, b]
  end

  def hash_input(input) do
    # Using pipe operator makes more idiomatic Elixir code. 
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    # Assign the value to the struct 
    %Identicon.Image{hex: hex}
  end
end
