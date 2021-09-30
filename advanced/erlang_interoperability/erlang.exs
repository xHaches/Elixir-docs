# Uno de los beneficios adicionales de construir sobre Erlang VM (BEAM) es la gran cantidad de bibliotecas existentes disponibles para nosotros. La interoperabilidad nos permite aprovechar esas bibliotecas y la biblioteca estándar de Erlang de nuestro código Elixir. En esta lección, veremos cómo acceder a la funcionalidad en la biblioteca estándar junto con los paquetes de Erlang de terceros.

# Librería estándar.
# Se puede acceder a la extensa biblioteca estándar de Erlang desde cualquier código Elixir en nuestra aplicación. Los módulos de Erlang están representados por átomos en minúsculas como: os y :timer.

# Usemos :timer.tc para cronometrar la ejecución de una función determinada:

defmodule Example do
  def timed(fun, args) do
    {time, result} = :timer.tc(fun, args)
    # Lo que pasa desde erlang:
    # Se activa cronometro:
    # Evalúa la función apply(fun, args) proveniente de la libreria estandar de erlang
    # apply/2 ejecuta una función dados los argumentos del 2do parametro
    # Al obtener el resultado de apply/2 se detiene el cronometro.
    IO.puts("Time: #{time} μs")
    IO.puts("Result: #{result}")
  end
end
iex> Example.timed(fn (n) -> (n * n) * n end, [100])
Time: 8 μs
Result: 1000000

# Para ver la lista completa de modulos disponibles ir a:
# https://erlang.org/doc/apps/stdlib/

# En una lección anterior, cubrimos Mix y la gestión de nuestras dependencias. La inclusión de bibliotecas de Erlang funciona de la misma manera. En el caso de que la biblioteca de Erlang no se haya enviado a Hex, puede consultar el repositorio de git en su lugar:

# mix.exs
def deps do
  [{:png, github: "yuce/png"}]
end

# Ahora podemos acceder a nuestra librería de Erlang:
png = :png.create(%{
    :size => {30, 30},
    :mode => {:indexed, 8},
    :file => file,
    :palette => palette
  }
)

# Diferencias notables

# Ahora que sabemos cómo usar Erlang, deberíamos cubrir algunas de las trampas que vienen con la interoperabilidad de Erlang.

# Atomos

# Los átomos de Erlang se parecen mucho a sus homólogos de Elixir sin los dos puntos (:). Están representados por cadenas en minúsculas y guiones bajos:

# Elixir:
:example
# Erlang
example.

# En Elixir, cuando hablamos de cadenas, nos referimos a binarios codificados en UTF-8. En Erlang, las cadenas todavía usan comillas dobles pero se refieren a listas de caracteres:

# Elixir
iex> is_list('Example')
true
iex> is_list("Example")
false
iex> is_binary("Example")
true
iex> <<"Example">> === "Example"
true

# Erlang:
1> is_list('Example').
false
2> is_list("Example").
true
3> is_binary("Example").
false
4> is_binary(<<"Example">>).
true

# Es importante tener en cuenta que muchas bibliotecas Erlang antiguas pueden no admitir binarios, por lo que debemos convertir las cadenas de Elixir en listas de caracteres. Afortunadamente, esto es fácil de lograr con la función to_charlist/1:

iex> :string.words("Hello World")
** (FunctionClauseError) no function clause matching in :string.strip_left/2

    The following arguments were given to :string.strip_left/2:

        # 1
        "Hello World"

        # 2
        32

    (stdlib) string.erl:1661: :string.strip_left/2
    (stdlib) string.erl:1659: :string.strip/3
    (stdlib) string.erl:1597: :string.words/2

iex> "Hello World" |> to_charlist() |> :string.words
2

# En Erlang, las variables empiezan con una letra mayúscula y la reasignación no es permitida

# Elixir

iex> x = 10
10

iex> x = 20
20

iex> x1 = x + 10
30

# Erlang

1> X = 10.
10

2> X = 20.
** exception error: no match of right hand side value 20

3> X1 = X + 10.
20

# ¡Eso es todo! Aprovechar Erlang desde nuestras aplicaciones Elixir es fácil y efectivamente duplica la cantidad de bibliotecas disponibles para nosotros.
