defmodule Identicon.Image do
	# Struct is a data structure that stores data. Can be assigned default values.
	# The only properties that can exist in the struct are the ones we assign in the module file.
	# With functional programming there are no class method etc.
	defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end