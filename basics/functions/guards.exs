# Guardias
# Cubrimos brevemente los guardias en la lección Estructuras de control, ahora veremos cómo podemos aplicarlos a funciones con nombre. Una vez que Elixir ha coincidido con una función, se probarán todos los guardias existentes.

# En el siguiente ejemplo, tenemos dos funciones con la misma firma, confiamos en los guardias para determinar cuál usar en función del tipo de argumento:

defmodule Greeter do
  def hello(names) when is_list(names) do
    names
    |> Enum.join(", ")
    |> hello
  end

  def hello(name) when is_binary(name) do
    phrase() <> name
  end

  defp phrase, do: "Hello, "
end

Greeter.hello(["Sean", "Steve"])
"Hello, Sean, Steve"
