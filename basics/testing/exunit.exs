# Testing

# Las pruebas son una parte importante del desarrollo de software. En esta lección, veremos cómo probar nuestro código Elixir con ExUnit y algunas de las mejores prácticas para hacerlo.

# ExUnit
# El marco de prueba integrado en Elixir es ExUnit e incluye todo lo que necesitamos para probar a fondo nuestro código. Antes de continuar, es importante tener en cuenta que las pruebas se implementan como scripts Elixir, por lo que debemos usar la extensión de archivo .exs. Antes de que podamos ejecutar nuestras pruebas, debemos iniciar ExUnit con ExUnit.start (), esto se hace más comúnmente en test / test_helper.exs.

# Cuando generamos nuestro proyecto de ejemplo en la lección anterior(documentation), la combinación fue lo suficientemente útil como para crear una prueba simple para nosotros, podemos encontrarla en test/greet_everyone_test.exs:

defmodule ExampleTest do
  use ExUnit.Case
  doctest Example

  test "greets the world" do
    assert Example.hello() == :world
  end
end

# Podemos ejecutar las pruebas de nuestro proyecto con:
$ mix test
# Si hacemos eso ahora, deberíamos ver una salida similar a:
# ..

# Finished in 0.03 seconds
# 2 tests, 0 failures

# ¿Por qué hay dos puntos en la salida de prueba? Además de la prueba en test/ example_test.exs, Mix también generó un doctest en lib/example.ex.

defmodule Example do
  @moduledoc """
  Documentation for Example.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Example.hello
      :world

  """
  def hello do
    :world
  end
end

# assert
# Si ha escrito pruebas antes, entonces está familiarizado con assert; en algunos marcos debería o esperar cumplir el papel de assert.

# Usamos la macro assert para probar que la expresión es verdadera. En caso de que no sea así, se generará un error y nuestras pruebas fallarán. Para probar una falla, cambiemos nuestra muestra y luego ejecutemos:
$ mix test

defmodule ExampleTest do
  use ExUnit.Case
  doctest Example

  test "greets the world" do
    assert Example.hello() == :word
  end
end

# Ahora deberíamos ver un tipo diferente de salida:

# 1) test greets the world (ExampleTest)
# test/example_test.exs:5
# Assertion with == failed
# code:  assert Example.hello() == :word
# left:  :world
# right: :word
# stacktrace:
#   test/example_test.exs:6 (test)

# .

# Finished in 0.03 seconds
# 2 tests, 1 failures

# ExUnit nos dirá exactamente dónde están nuestras afirmaciones fallidas, cuál fue el valor esperado y cuál fue el valor real.

# refute
# refute es assert como unless es a if. Utilice refute cuando quiera asegurarse de que una declaración sea siempre falsa.

# assert_raise

# A veces puede ser necesario afirmar que se ha producido un error. Podemos hacer esto con assert_raise. Veremos un ejemplo de assert_raise en la próxima lección sobre Plug.

# assert_receive
# En Elixir, las aplicaciones consisten en actores / procesos que se envían mensajes entre sí, por lo tanto, querrá probar los mensajes que se envían. Dado que ExUnit se ejecuta en su propio proceso, puede recibir mensajes como cualquier otro proceso y puede afirmarlo con la macro assert_received:

defmodule SendingProcess do
  def run(pid) do
    send(pid, :ping)
  end
end

defmodule TestReceive do
  use ExUnit.Case

  test "receives ping" do
    SendingProcess.run(self())
    assert_received :ping
  end
end

# assert_received no espera mensajes, con assert_receive puede especificar un tiempo de espera.

# capture_io y capture_log
# Es posible capturar la salida de una aplicación con ExUnit.CaptureIO sin cambiar la aplicación original. Simplemente pase la función que genera la salida en:

defmodule OutputTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "outputs Hello World" do
    assert capture_io(fn -> IO.puts("Hello World") end) == "Hello World\n"
  end
end

# ExUnit.CaptureLog es el equivalente para capturar la salida en Logger.

# Configuración de prueba
# En algunos casos, puede ser necesario realizar la configuración antes de nuestras pruebas. Para lograr esto, podemos usar las macros setup y setup_all. setup se ejecutará antes de cada prueba y setup_all una vez antes de la suite. Se espera que devuelvan una tupla de {:ok, state}, el estado estará disponible para nuestras pruebas.

# Por ejemplo, cambiaremos nuestro código para usar setup_all:

defmodule ExampleTest do
  use ExUnit.Case
  doctest Example

  setup_all do
    {:ok, recipient: :world}
  end

  test "greets", state do
    assert Example.hello() == state[:recipient]
  end
end

# Test Mocks
# Queremos tener cuidado con la forma en que pensamos sobre "mock". Cuando hacemos mocks de ciertas interacciones creando stubs de funciones únicas en un ejemplo de prueba dado, establecemos un patrón peligroso. Acoplamos la ejecución de nuestras pruebas al comportamiento de una dependencia en particular, como un cliente API. Evitamos definir el comportamiento compartido entre nuestras funciones stubped. Hacemos que sea más difícil iterar en nuestras pruebas.

# En cambio, la comunidad de Elixir nos anima a cambiar la forma en que pensamos sobre los test mocks; que pensamos en un mock como un sustantivo, en lugar de un verbo.

# La esencia es que, en lugar hacer mocks de las dependencias para las pruebas (mocks como verbo), tiene muchas ventajas definir explícitamente interfaces (behaviors) para el código fuera de su aplicación y usar implementaciones simuladas (como sustantivo) en su código para las pruebas.

# Para aprovechar este patrón de "mocks-as-a-noun", puede:

# Defina un behaviour que sea implementado tanto por la entidad para la que le gustaría definir un mock como por el módulo que actuará como mock.
# Definir el módulo mock
# Configure el código de su aplicación para usar el mock en el entorno de prueba o prueba dado, por ejemplo, pasando el módulo mock a una llamada de función como argumento o configurando su aplicación para usar el módulo mock en el entorno de prueba.
# Para una inmersión más profunda en los mocks de prueba en Elixir, y una mirada a la biblioteca de Mox que le permite definir mocks concurrentes, consulte nuestra lección sobre Mox aquí
