# Funciones privadas
# Cuando no queremos que otros módulos accedan a una función especifica, podemos hacer que la función sea privada. Las funciones privadas solo pueden ser llamadas desde su propio modulo. Las definimos en Elixir con defp:

defmodule Greeter do
  def hello(name), do: phrase() <> name
  defp phrase, do: "Hello, "
end

Greeter.hello("Sean")
"Hello, Sean"

Greeter.phrase()
# ** (UndefinedFunctionError) function Greeter.phrase/0 is undefined or private
