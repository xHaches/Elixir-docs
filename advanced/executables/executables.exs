# Ejecutables
# Para construir un ejecutable usaremos escript. Escript genera un ejecutable que puede correr en cualquier sistema con Erlang instalado

# Para crear un ejecutable con escript, solo hay algunas cosas que debemos hacer: implementar una función main/1 y actualizar nuestro Mixfile.

# Comenzaremos creando un módulo que sirva como punto de entrada a nuestro ejecutable. Aquí es donde implementaremos main/1:

defmodule ExampleApp.CLI do
  def main(args \\ []) do
    # Do stuff
  end
end

# A continuación, debemos actualizar nuestro Mixfile para incluir la opción: escript para nuestro proyecto junto con la especificación de nuestro: main_module:

defmodule ExampleApp.Mixproject do
  def project do
    [app: :example_app, version: "0.0.1", escript: escript()]
  end

  defp escript do
    [main_module: ExampleApp.CLI]
  end
end

# Analizando (parsing) argumentos

# Con nuestra aplicación configurada, podemos pasar a analizar los argumentos de la línea de comandos. Para hacer esto usaremos OptionParser.parse / 2 de Elixir con la opción: switches para indicar que nuestra bandera es booleana:

defmodule ExampleApp.CLI do
  def main(args \\ []) do
    args
    |> parse_args()
    |> response()
    |> IO.puts()
  end

  defp parse_args(args) do
    {opts, word, _} =
      args
      |> OptionParser.parse(switches: [upcase: :boolean])

    {opts, List.to_string(word)}
  end

  defp response({opts, word}) do
    if opts[:upcase], do: String.upcase(word), else: word
  end
end

# Build de la app
# Una vez que hayamos terminado de configurar nuestra aplicación para usar escript, construir nuestro ejecutable es muy sencillo con Mix:
$ mix escript.build

# Vamos a probar
$ ./example_app --upcase Hello
HELLO

$ ./example_app Hi
Hi

# Eso es todo, hemos creado nuestro primer ejecutable en Elixir usando escript.
