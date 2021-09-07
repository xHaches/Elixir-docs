# Módulos
# Los módulos son la mejor manera de organizar funciones en un namespace. En adición a las funciones agrupativas, los módulos nos permiten definir funciones nombradas y privadas, las cuales cubrimos en la lección pasada.

# Démosle un vistazo a un ejemplo básico:
defmodule Example do
  def greeting(name) do
    "Hello #{name}."
  end
end

Example.greeting("Sean")
"Hello Sean."

# Es posible anidar módulos en Elixir, permitiéndonos ser explícitos nombrando nuestra funcionalidad.
defmodule Example.Greetings do
  def morning(name) do
    "Good morning #{name}."
  end

  def evening(name) do
    "Good night #{name}."
  end
end

Example.Greetings.morning("Sean")
# "Good morning Sean."

# Atributos de un Módulo
# Los atributos de un módulo son comúnmente usados como constantes en Elixir. Démosle un vistazo al siguiente ejemplo:

defmodule Example do
  @greeting "Hello"

  def greeting(name) do
    ~s(#{@greeting} #{name}.)
  end
end

# Es importante destacar que hay atributos reservados en Elixir. Los tres más comunes son:

# moduledoc — Documenta el módulo actual.
# doc — Documentación para funciones y macros.
# behaviour — Usa OTP o comportamiento definido por el usuario.
