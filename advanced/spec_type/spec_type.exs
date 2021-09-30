# No es raro que le gustaría describir la interfaz de su función. Puede usar la anotación @doc, pero es solo información para otros desarrolladores que no se verifica en el tiempo de compilación. Para este propósito, Elixir tiene la anotación @spec para describir la especificación de una función que será verificada por el compilador.

# Sin embargo, en algunos casos, la especificación será bastante grande y complicada. Si desea reducir la complejidad, desea introducir una definición de tipo personalizada. Elixir tiene la anotación @type para eso. Por otro lado, Elixir sigue siendo un lenguaje dinámico. Eso significa que el compilador ignorará toda la información sobre un tipo, pero otras herramientas podrían utilizarla.

# Specification

# Si tiene experiencia con Java, podría pensar en la especificación como una interfaz. La especificación define cuál debería ser el tipo de parámetros de una función y su valor de retorno.

# Para definir los tipos de entrada y salida usamos la directiva @spec colocada justo antes de la definición de la función y tomando como parámetro el nombre de la función, una lista de tipos de parámetros y después :: el tipo del valor de retorno.

# Veamos un ejemplo:

defmodule Example do
  @spec sum_product(integer) :: integer
  def sum_product(a) do
    [1, 2, 3]
    |> Enum.map(fn el -> el * a end)
    |> Enum.sum()
  end
end

# Todo se ve bien y cuando lo llamemos, se devolverá un resultado válido, pero la función Enum.sum devuelve un número, no un entero como esperábamos en @spec. ¡Podría ser una fuente de errores! Existen herramientas como Dialyzer para realizar análisis estáticos de código que nos ayudan a encontrar este tipo de error. Hablaremos de ellos en otra lección.

# Custom types

# Escribir especificaciones es bueno, pero a veces nuestras funciones funcionan con estructuras de datos más complejas que simples números o colecciones. En el caso de esa definición en @spec, podría ser difícil de entender y / o cambiar para otros desarrolladores. A veces, las funciones necesitan tomar una gran cantidad de parámetros o devolver datos complejos. Una lista larga de parámetros es uno de los muchos posibles malos olores en el código de uno. En lenguajes orientados a objetos como Ruby o Java podríamos definir fácilmente clases que nos ayuden a resolver este problema. Elixir no tiene clases pero debido a que es fácil de extender, podemos definir nuestros propios tipos.

# Elixir listo para usar contiene algunos tipos básicos como integer o pid. Puede encontrar la lista completa de tipos disponibles en la documentación.

# https://hexdocs.pm/elixir/typespecs.html#types-and-their-syntax

# Definición de tipo personalizado
# Modifiquemos nuestra función sum_times e introduzcamos algunos parámetros adicionales:

defmodule Example do
  @spec sum_times(integer, %Examples{first: integer, last: integer}) :: integer
  def sum_times(a, params) do
    for i <- params.first..params.last do
      i
    end
    |> Enum.map(fn el -> el * a end)
    |> Enum.sum()
    |> round
  end
end

# Introdujimos una estructura en el módulo de Ejemplo que contiene dos campos: first y last. Esta es una versión más simple de la estructura del módulo Range. Para obtener más información sobre estructuras, consulte la sección sobre módulos. Imaginemos que necesitamos una especificación con una estructura de ejemplos en muchos lugares. Sería molesto escribir especificaciones largas y complejas y podría ser una fuente de errores. Una solución a este problema es @type.

# Elixir tiene tres directivas para los tipos:

# @type: tipo público simple. La estructura interna del tipo es pública.
# @typep: el tipo es privado y solo se puede usar en el módulo donde está definido.
# @opaque: el tipo es público, pero la estructura interna es privada.
# Definamos nuestro tipo:

defmodule Examples do
  defstruct first: nil, last: nil

  @type t(first, last) :: %Examples{first: first, last: last}

  @type t :: %Examples{first: integer, last: integer}
end

# Ya definimos el tipo t(first, last), que es una representación de la estructura:

# %Examples{first: first, last: last}.

# En este punto, vemos que los tipos pueden tomar parámetros, pero también definimos el tipo t y esta vez es una representación de la estructura

# %Examples{first: integer, last: integer}

# ¿Cuál es la diferencia? El primero representa la estructura. Ejemplos en los que las dos claves pueden ser de cualquier tipo. El segundo representa la estructura en la que las claves son números enteros. Esto significa que el código que se ve así:

defmodule Examples do
  defstruct first: nil, last: nil

  @type t(first, last) :: %Examples{first: first, last: last}

  @type t :: %Examples{first: integer, last: integer}

  @spec sum_times(integer, Examples.t()) :: integer
  def sum_times(a, params) do
    for i <- params.first..params.last do
      i
    end
    |> Enum.map(fn el -> el * a end)
    |> Enum.sum()
    |> round
  end
end

# Es igual a un código como:

defmodule Examples do
  defstruct first: nil, last: nil

  @type t(first, last) :: %Examples{first: first, last: last}

  @type t :: %Examples{first: integer, last: integer}

  # @spec sum_times(integer, Examples.t()) :: integer
  @spec sum_times(integer, Examples.t(integer, integer)) :: integer
  def sum_times(a, params) do
    for i <- params.first..params.last do
      i
    end
    |> Enum.map(fn el -> el * a end)
    |> Enum.sum()
    |> round
  end
end

# Documentación de tipos
# El último elemento del que debemos hablar es cómo documentar nuestros tipos. Como sabemos por la lección de documentación, tenemos anotaciones @doc y @moduledoc para crear documentación para funciones y módulos. Para documentar nuestros tipos podemos usar @typedoc:

defmodule Examples do
  @typedoc """
      Type that represents Examples struct with :first as integer and :last as integer.
  """
  @type t :: %Examples{first: integer, last: integer}
end
La directiva @typedoc es similar a @doc and @moduledoc.


# libreria Dialyzer analisis estaticos de codigo
