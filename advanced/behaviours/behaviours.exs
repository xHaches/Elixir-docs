# Comportamientos
# Aprendimos sobre Typespecs en la lección anterior, aquí aprenderemos cómo requerir un módulo para implementar esas especificaciones. En Elixir, esta funcionalidad se conoce como comportamientos.

# Elixir incluye una serie de comportamientos como GenServer, pero en esta lección nos centraremos en crear el nuestro.

# Definiendo un comportamiento(behaviour)

# Para comprender mejor los comportamientos, implementemos uno para un módulo worker. Se espera que estos workers implementen dos funciones: init/1 y perform/2.

# Para lograr esto, usaremos la directiva @callback con una sintaxis similar a @spec. Esto define una función requerida; para macros podemos usar @macrocallback. Especifiquemos las funciones init / 1 y perform / 2 para nuestros trabajadores:

defmodule Example.Worker do
  @callback init(state :: term) :: {:ok, new_state :: term} | {:error, reason :: term}
  @callback perform(args :: term, state :: term) ::
              {:ok, result :: term, new_state :: term}
              | {:error, reason :: term, new_state :: term}
end

# usando un behaviour

# Ahora que hemos definido nuestro comportamiento, podemos usarlo para crear una variedad de módulos que comparten la misma API pública. Agregar un comportamiento a nuestro módulo es fácil con el atributo @behaviour.

# Usando nuestro nuevo comportamiento, creemos un módulo cuya tarea será descargar un archivo remoto y guardarlo localmente:

defmodule Example.Downloader do
  @behaviour Example.Worker

  def init(opts), do: {:ok, opts}

  def perform(url, opts) do
    url
    |> HTTPoison.get!()
    |> Map.fetch(:body)
    |> write_file(opts[:path])
    |> respond(opts)
  end

  defp write_file(:error, _), do: {:error, :missing_body}

  defp write_file({:ok, contents}, path) do
    path
    |> Path.expand()
    |> File.write(contents)
  end

  defp respond(:ok, opts), do: {:ok, opts[:path], opts}
  defp respond({:error, reason}, opts), do: {:error, reason, opts}
end

# ¿O qué tal un trabajador que comprime una serie de archivos? Eso también es posible:

defmodule Example.Compressor do
  @behaviour Example.Worker

  def init(opts), do: {:ok, opts}

  def perform(payload, opts) do
    payload
    |> compress
    |> respond(opts)
  end

  defp compress({name, files}), do: :zip.create(name, files)

  defp respond({:ok, path}, opts), do: {:ok, path, opts}
  defp respond({:error, reason}, opts), do: {:error, reason, opts}
end

# Si bien el trabajo realizado es diferente, la API de cara al público no lo es, y cualquier código que aproveche estos módulos puede interactuar con ellos sabiendo que responderán como se espera. Esto nos da la capacidad de crear cualquier número de workers, todos realizando diferentes tareas, pero conforme a la misma API pública.

# Si agregamos un comportamiento pero no implementamos todas las funciones requeridas, se generará una advertencia de tiempo de compilación. Para ver esto en acción, modifiquemos nuestro código Example.Compressor eliminando la función init / 1:

defmodule Example.Compressor do
  @behaviour Example.Worker

  def perform(payload, opts) do
    payload
    |> compress
    |> respond(opts)
  end

  defp compress({name, files}), do: :zip.create(name, files)

  defp respond({:ok, path}, opts), do: {:ok, path, opts}
  defp respond({:error, reason}, opts), do: {:error, reason, opts}
end

# Ahora, cuando compilemos nuestro código, deberíamos ver una advertencia:

# lib/example/compressor.ex:1: warning: undefined behaviour function init/1 (for behaviour Example.Worker)
# Compiled lib/example/compressor.ex
