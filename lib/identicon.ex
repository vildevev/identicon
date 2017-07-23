defmodule Identicon do
  
  def main(input) do
    # First object given to pipe operator will be passed down as first argument.
    input 
    |> hash_input
  end

  def hash_input(input) do
    # Using pipe operator makes more idiomatic Elixir code. 
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end