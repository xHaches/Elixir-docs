defmodule MySigils do
  def sigil_u(string, []), do: String.upcase(string)
end
