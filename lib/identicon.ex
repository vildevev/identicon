defmodule Identicon do
  def main(input) do
    # First object given to pipe operator will be passed down as first argument.
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    # Argument provided will be the second argument
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)
    # For doing a processing step on each element. Not transforming it.
    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end 
    # returns image by using the Erlang graphical library. 
    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    # Underscore in front means that we adknowledge that an element is there, but that we don't care about it.
    # Not an actual index. Just referring to the 'fake' indeces made earlier.
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end 
    # Must add 'pixel_map' property to struct for this to work.
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    # Helper function that return true for even numbers.
    grid = Enum.filter grid, fn({code, _index}) ->
      # 'rem' returns remainder
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      # Enum.chunk returns a list with nested lists that have 3 elements each. 
      |> Enum.chunk(3)
      # Pass reference to a function. '/' how many arguments the function takes.
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      # Turns every element into a two element tuple. 
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    # ++ is for joining lists
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # Use pattern matching to set the list equal to the hex_list variable.
    # Have to perfectly describe element on the right for pattern matching to work unless using pipe and '_tail'.
    # Only care about the first three elements
    # Pattern match directly out of argument list.
    # We don't modify existing data. We are creating an entirely new struct that's smiliar to the original with new colors added.
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    # Using pipe operator makes more idiomatic Elixir code.
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    # Assign the value to the struct 
    %Identicon.Image{hex: hex}
  end
end
