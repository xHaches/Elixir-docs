# Podemos definir funciones con nombre para así poder referirnos a ellas luego. Estas funciones con nombre son definidas con la palabra clave def dentro de un módulo.

# Las funciones definidas dentro de un módulo están disponibles para ser usadas por otros módulos, esto es particularmente útil para construir bloques en Elixir:

defmodule Greeter do
  def hello(name) do
    "Hello, " <> name
  end
end

Greeter.hello("Sean")
# Hello, Sean

# Si el cuerpo de nuestra función solo se extiende a una línea, podemos acortarla con do:
defmodule Greeter2 do
  def hello(name), do: "Hello, " <> name
end

# Armados con nuestro conocimiento de coincidencia de patrones, vamos a explorar la recursión usando funciones con nombre:
defmodule Length do
  def of([]), do: 0
  def of([_ | tail]) do: 1 + of(tail)
end

Length.of([])
# 0
Length.of([1, 2, 3])
# 3

# Nombre de funciones y aridad
# Anteriormente mencionamos que las funciones son nombradas por la combinación de nombre y aridad (cantidad de argumentos). Esto significa que puedes hacer cosas como:
defmodule Greeter3 do
  def hello(), do: "Hello, anonymous person!"
  def hello(name), do: "Hello, " <> name
  def hello(name1, name2), do: "Hello, #{name1} and #{name2}"
end

Greeter3.hello()
# "Hello, anonymous person!"
Greeter3.hello("Fred")
# "Hello, Fred"
Greeter3.hello("Fred", "Jane")
# "Hello, Fred and Jane"

# Enumeramos los nombres de las funciones en los comentarios anteriores. La primera implementación no recibe argumentos, su equivalente es hello/0; la segunda función recibe un argumento equivalente a hello/1, y así. A diferencia de la sobrecarga en otros lenguajes, estas son consideradas funciones diferentes entre si. (La coincidencia de patrones, descrita anteriormente, aplica solo cuando se definen varias funciones con el mismo nombre y el mismo numero de argumentos).
