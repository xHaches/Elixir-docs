# Documentación
# Elixir trata a la documentación como ciudadanos de primera clase, ofreciendo varias funciones para acceder y generar documentación para tus proyectos

# (#) Para documentación en linea
# @moduledoc Para documentación a nivel módulo
# @doc Para documentación a nivel función

# Documentación entre líneas

# Outputs 'Hello, chum.' to the console.
IO.puts("Hello, " <> "chum.")

# Documentando módulos
# El anotador @moduledoc permite la documentación en línea a nivel de módulo. Por lo general, se encuentra justo debajo de la declaración defmodule en la parte superior de un archivo. El siguiente ejemplo muestra un comentario de una línea dentro del decorador @moduledoc.

defmodule Greeter do
  @moduledoc """
  Provides a function `hello/1` to greet a human
  """

  def hello(name) do
    "Hello, " <> name
  end
end

# We (or others) can access this module documentation using the h helper function within IEx. We can see this for ourselves if we put our Greeter module into a new file, greeter.ex and compile it:

c("greeter.ex", ".")
# [Greeter]

h Greeter

# Provides a function hello/1 to greet a human

# Nota: no necesitamos compilar manualmente nuestros archivos como hicimos anteriormente si estamos trabajando en el contexto de un proyecto mix. Puede usar
$ iex -S mix
# para cargar la consola IEx para el proyecto actual si está trabajando en un proyecto mixto.

# Documentando funciones
# Así como Elixir nos da la capacidad de realizar anotaciones a nivel de módulo, también permite anotaciones similares para documentar funciones. El anotador @doc permite la documentación en línea a nivel de función. El anotador @doc se encuentra justo encima de la función que está anotando.

defmodule Greeter do
  @moduledoc """
  ...
  """

  @doc """
  Prints a hello message.

  ## Parameters

    - name: String that represents the name of the person.

  ## Examples

      iex> Greeter.hello("Sean")
      "Hello, Sean"

      iex> Greeter.hello("pete")
      "Hello, pete"

  """
  @spec hello(String.t()) :: String.t()
  def hello(name) do
    "Hello, " <> name
  end
end

# Si iniciamos IEx nuevamente y usamos el comando (h) en la función antepuesta con el nombre del módulo, deberíamos ver lo siguiente:

# iex> c("greeter.ex", ".")
# [Greeter]

# iex> h Greeter.hello

#                 def hello(name)

#   @spec hello(String.t()) :: String.t()

# Prints a hello message.

# Parameters

#   • name: String that represents the name of the person.

# Examples

#     iex> Greeter.hello("Sean")
#     "Hello, Sean"

#     iex> Greeter.hello("pete")
#     "Hello, pete"

# ¿Observa cómo puede usar el marcado dentro de nuestra documentación y el terminal lo renderizará? Además de ser realmente genial y una adición novedosa al vasto ecosistema de Elixir, se vuelve mucho más interesante cuando miramos ExDoc para generar documentación HTML sobre la marcha.

# Nota: la anotación @spec se utiliza para analizar estáticamente el código. Para obtener más información al respecto, consulte la lección Especificaciones y tipos.

# ExDoc
# ExDoc es un proyecto oficial de Elixir que se puede encontrar en GitHub. Produce HTML (HyperText Markup Language) y documentación en línea para proyectos Elixir. Primero, creemos un proyecto Mix para nuestra aplicación:

$ mix new greet_everyone

# Ahora copie y pegue el código de la lección del anotador @doc en un archivo llamado lib / greeter.ex y asegúrese de que todo sigue funcionando desde la línea de comandos. Ahora que estamos trabajando dentro de un proyecto Mix, necesitamos iniciar IEx de manera un poco diferente usando la secuencia de comando

$ iex -S mix:

$ h Greeter.hello

# Instalando ExDoc

# Suponiendo que todo está bien y estamos viendo el resultado anterior, ahora estamos listos para configurar ExDoc. En el archivo mix.exs, agregue la dependencia: ex_doc para comenzar.

def deps do
  [{:ex_doc, "~> 0.21", only: :dev, runtime: false}]
end


# Especificamos el par key-value only: :dev ya que no queremos descargar y compilar la dependencia ex_doc en un entorno de producción.

# ex_doc también agregará otra biblioteca para nosotros, Earmark.

# Earmark es un analizador de Markdown para el lenguaje de programación Elixir que ExDoc utiliza para convertir nuestra documentación dentro de @moduledoc y @doc en un hermoso HTML.

# Vale la pena señalar en este punto que cambia la herramienta de marcado a Cmark si lo desea, pero deberá realizar un poco más de configuración, sobre la que puede leer aquí. Para este tutorial, solo nos quedaremos con Earmark.

# Generando documentación
# Continuando, desde la línea de comando ejecute los siguientes dos comandos:
$ mix deps.get # gets ExDoc + Earmark.
$ mix docs # makes the documentation.

# Docs successfully generated.
# View them at "doc/index.html".

# Si todo salió según lo planeado, debería ver un mensaje similar al mensaje de salida en el ejemplo anterior. Veamos ahora dentro de nuestro proyecto Mix y deberíamos ver que hay otro directorio llamado doc /. Dentro está nuestra documentación generada.

# Podemos ver que Earmark ha renderizado nuestro Markdown y ExDoc ahora lo muestra en un formato útil.

# Ahora podemos desplegar esto en GitHub, nuestro propio sitio web o, más comúnmente, HexDocs.

# La documentación debe agregarse dentro de las Directrices de mejores prácticas del idioma. Dado que Elixir es un lenguaje bastante joven, aún quedan muchos estándares por descubrir a medida que crece el ecosistema. La comunidad, sin embargo, trató de establecer las mejores prácticas. Para leer más sobre las mejores prácticas, consulte La guía de estilo Elixir.

# Documente siempre un módulo.
defmodule Greeter do
  @moduledoc """
  This is good documentation.
  """

end


# Si no tiene la intención de documentar un módulo, no lo deje en blanco. Considere anotar el módulo como falso, así:

defmodule Greeter do
  @moduledoc false

end


# Cuando se refiera a funciones dentro de la documentación del módulo, use comillas invertidas como esta:
defmodule Greeter do
  @moduledoc """
  ...

  This module also has a `hello/1` function.
  """

  def hello(name) do
    IO.puts("Hello, " <> name)
  end
end

# Separe todos y cada uno de los códigos en una línea debajo de @moduledoc de la siguiente manera:
defmodule Greeter do
  @moduledoc """
  ...

  This module also has a `hello/1` function.
  """

  alias Goodbye.bye_bye
  # and so on...

  def hello(name) do
    IO.puts("Hello, " <> name)
  end
end

# Utilice Markdown en los documentos. Facilitará la lectura a través de IEx o ExDoc.
defmodule Greeter do
  @moduledoc """
  ...
  """

  @doc """
  Prints a hello message

  ## Parameters

    - name: String that represents the name of the person.

  ## Examples

      iex> Greeter.hello("Sean")
      "Hello, Sean"

      iex> Greeter.hello("pete")
      "Hello, pete"

  """
  @spec hello(String.t()) :: String.t()
  def hello(name) do
    "Hello, " <> name
  end
end

# Intente incluir algunos ejemplos de código en su documentación. Esto también le permite generar pruebas automáticas a partir de los ejemplos de código que se encuentran en un módulo, función o macro con ExUnit.DocTest. Para hacer eso, debe invocar la macro doctest / 1 de su caso de prueba y escribir sus ejemplos de acuerdo con algunas pautas como se detalla en la documentación oficial.


# List module attributes, directives, and macros in the following order

# @moduledoc
# @behaviour
# use
# import
# require
# alias
# @module_attribute
# defstruct
# @type
# @callback
# @macrocallback
# @optional_callbacks
# defmacro, defmodule, defguard, def, etc.
