# Ahora que sabemos cómo crear módulos y estructuras, aprendamos a agregarle funciones existentes a través de la composición. Elixir nos proporciona una variedad de formas diferentes de interactuar con otros módulos.

# alias
# Nos permite darle un alias a los módulos, que son usados frecuentemente en Elixir.

defmodule Sayings.Greetings do
  def basic(name), do: "Hi, #{name}"
end

defmodule Example do
  alias Sayings.Greetings

  def greeting(name), do: Greetings.basic(name)
end

# Without alias

defmodule Example do
  def greeting(name), do: Sayings.Greetings.basic(name)
end

# Si hay un conflicto entre dos alias o quieres que los alias tomen un nombre diferente, podemos utilizar la opción :as
defmodule Example do
  alias Sayings.Greetings, as: Hi

  def print_message(name), do: Hi.basic(name)
end

# Es posible dar múltiples alias a un módulo a la vez:
defmodule Example do
  alias Sayings.{Greetings, Farewells}
end
