# No es raro querer ampliar la funcionalidad de sus aplicaciones Elixir agregando tareas de Mix personalizadas. Antes de aprender a crear tareas mix específicas para nuestros proyectos, veamos una que ya existe:

$ mix phx.new my_phoenix_app

* creating my_phoenix_app/config/config.exs
* creating my_phoenix_app/config/dev.exs
* creating my_phoenix_app/config/prod.exs
* creating my_phoenix_app/config/prod.secret.exs
* creating my_phoenix_app/config/test.exs
* creating my_phoenix_app/lib/my_phoenix_app.ex
* creating my_phoenix_app/lib/my_phoenix_app/endpoint.ex
* creating my_phoenix_app/test/views/error_view_test.exs
...

# Como podemos ver en el comando de shell anterior, Phoenix Framework tiene una tarea Mix personalizada para generar un nuevo proyecto. ¿Y si pudiéramos crear algo similar para nuestro proyecto? Bueno, la buena noticia es que podemos, y Elixir nos lo facilita.

# configuración
# Let’s set up a basic Mix application.

$ mix new hello

* creating README.md
* creating .formatter.exs
* creating .gitignore
* creating mix.exs
* creating lib
* creating lib/hello.ex
* creating test
* creating test/test_helper.exs
* creating test/hello_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

cd hello
mix test

Run "mix help" for more commands.

# Ahora, en nuestro archivo lib / hello.ex que Mix generó para nosotros, creemos una función simple que dará como resultado "¡Hola, mundo!"

defmodule Hello do
  @doc """
  Outputs `Hello, World!` every time.
  """
  def say do
    IO.puts("Hello, World!")
  end
end

# Custom mix task

# crearemos custom Mix task. creamos un directorio y un archivo en hello/lib/mix/tasks/hello.ex. Dentro de este archivo, insertamos 7 líneas de código Elixir.

defmodule Mix.Tasks.Hello do
  @moduledoc "The hello mix task: `mix help hello`"
  use Mix.Task

  @shortdoc "Simply calls the Hello.say/0 function."
  def run(_) do
    # calling our Hello.say() function from earlier
    Hello.say()
  end
end

# Observe cómo comenzamos la declaración defmodule con Mix.Tasks y el nombre que queremos llamar desde la línea de comando. En la segunda línea, presentamos el uso Mix.Task que trae el comportamiento Mix.Task al espacio de nombres. Luego declaramos una función de ejecución que ignora cualquier argumento por ahora. Dentro de esta función, llamamos a nuestro módulo Hello y a la función say.

# Cargando tu aplicación

# Mix no inicia automáticamente nuestra aplicación o cualquiera de sus dependencias, lo cual está bien para muchos casos de uso de tareas Mix, pero ¿qué pasa si necesitamos usar Ecto e interactuar con una base de datos? En ese caso, debemos asegurarnos de que la aplicación detrás de Ecto.Repo se haya iniciado. Hay 2 formas de manejar esto: iniciando explícitamente una aplicación o podemos iniciar nuestra aplicación que a su vez iniciará las demás.

# Veamos cómo podemos actualizar nuestra tarea Mix para iniciar nuestra aplicación y dependencias:

defmodule Mix.Tasks.Hello do
  @moduledoc "The hello mix task: `mix help hello`"
  use Mix.Task

  @shortdoc "Simply calls the Hello.say/0 function."
  def run(_) do
    # This will start our application
    Mix.Task.run("app.start")

    Hello.say()
  end
end

# Mix tasks en acción

# Revisemos nuestra tarea mixta. Mientras estemos en el directorio, debería funcionar. Desde la línea de comando, ejecute

$ mix hello

# y deberíamos ver lo siguiente:

$ mix hello
Hello, World!

# Mix es bastante amigable por defecto. Sabe que todo el mundo puede cometer un error ortográfico de vez en cuando, por lo que utiliza una técnica llamada coincidencia de cadenas difusas para hacer recomendaciones:

$ mix hell

** (Mix) The task "hell" could not be found. Did you mean "hello"?

# ¿También notó que introdujimos un nuevo atributo de módulo, @shortdoc? Esto resulta útil cuando se envía nuestra aplicación, como cuando un usuario ejecuta el comando mix help desde la terminal.

$ mix help

mix app.start         # Starts all registered apps
...
mix hello             # Simply calls the Hello.say/0 function.
...


# Nota: Nuestro código debe compilarse antes de que aparezcan nuevas tareas en la salida mix help. Podemos hacer esto ejecutando mix compile directamente o ejecutando nuestra tarea como hicimos con mix hello, lo que activará la compilación por nosotros.
