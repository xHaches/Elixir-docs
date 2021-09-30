# Testing a código distribuido

# Comencemos escribiendo una prueba simple para nuestra función send_message.

# test/chat_test.exs
defmodule ChatTest do
  use ExUnit.Case, async: true
  doctest Chat

  test "send_message" do
    assert Chat.send_message(:moebi@localhost, "hi") == :ok
  end
end

# Si ejecutamos nuestras pruebas a través de la prueba de mezcla, vemos que falla con el siguiente error:

** (exit) exited in: GenServer.call({Chat.TaskSupervisor, :moebi@localhost}, {:start_task, [#PID<0.158.0>, :monitor, {:sophie@localhost, #PID<0.158.0>}, {Chat, :receive_message_for_moebi, ["hi", :sophie@localhost]}], :temporary, nil}, :infinity)
         ** (EXIT) no connection to moebi@localhost

# Este error tiene mucho sentido: no podemos conectarnos a un nodo llamado moebi @ localhost porque no existe tal nodo en ejecución.

# Podemos hacer que esta prueba pase realizando algunos pasos:

# Abra otra ventana de terminal y ejecute el nodo nombrado:

$ iex --sname moebi@localhost -S mix

# Ejecute las pruebas en la primera terminal a través de un nodo con nombre que ejecuta las pruebas mixtas en una sesión iex:

$ iex --sname sophie@localhost -S mix test

# Esto es mucho trabajo y definitivamente no se consideraría un proceso de prueba automatizado.

# Hay dos enfoques diferentes que podríamos tomar aquí:

# Excluya condicionalmente las pruebas que necesiten nodos distribuidos, si el nodo necesario no se está ejecutando.
# Configure nuestra aplicación para evitar generar tareas en nodos remotos en el entorno de prueba.
# Echemos un vistazo al primer enfoque.

# Excluir condicionalmente pruebas con etiquetas
# Agregaremos una etiqueta ExUnit a esta prueba:

# test/chat_test.exs
defmodule ChatTest do
  use ExUnit.Case, async: true
  doctest Chat

  @tag :distributed
  test "send_message" do
    assert Chat.send_message(:moebi@localhost, "hi") == :ok
  end
end

# And we’ll add some conditional logic to our test helper to exclude tests with such tags if the tests are not running on a named node.

# test/test_helper.exs
exclude =
  if Node.alive?, do: [], else: [distributed: true]

ExUnit.start(exclude: exclude)

# Comprobamos si el nodo está vivo, es decir, si el nodo forma parte de un sistema distribuido con Node.alive ?. Si no, podemos decirle a ExUnit que omita cualquier prueba con la etiqueta distribuida: true. De lo contrario, le indicaremos que no excluya ninguna prueba.

# Ahora, si ejecutamos una prueba de mezcla antigua simple, veremos:

mix test
Excluding tags: [distributed: true]

Finished in 0.02 seconds
1 test, 0 failures, 1 excluded

# Y si queremos ejecutar nuestras pruebas distribuidas, simplemente debemos seguir los pasos descritos en la sección anterior: ejecutar el nodo moebi@localhost y ejecutar las pruebas en un nodo con nombre a través de iex.

# Echemos un vistazo a nuestro otro enfoque de prueba: configurar la aplicación para que se comporte de manera diferente en diferentes entornos.

# Configuración de aplicaciones específicas del entorno

# La parte de nuestro código que le dice a Task.Supervisor que inicie una tarea supervisada en un nodo remoto está aquí:

# app/chat.ex
def spawn_task(module, fun, recipient, args) do
  recipient
  |> remote_supervisor()
  |> Task.Supervisor.async(module, fun, args)
  |> Task.await()
end

defp remote_supervisor(recipient) do
  {Chat.TaskSupervisor, recipient}
end

# Task.Supervisor.async/5 toma un primer argumento del supervisor que queremos usar. Si pasamos una tupla de {SupervisorName, location}, iniciará el supervisor dado en el nodo remoto dado. Sin embargo, si pasamos a Task.Supervisor un primer argumento del nombre de un supervisor, usará ese supervisor para supervisar la tarea localmente.

# Hagamos que la función remote_supervisor/1 sea configurable según el entorno. En el entorno de desarrollo, devolverá {Chat.TaskSupervisor, destinatario} y en el entorno de prueba devolverá Chat.TaskSupervisor

# Haremos esto a través de variables de aplicación.

# Cree un archivo, config/dev.exs y agregue:

# config/dev.exs
use Mix.Config
config :chat, remote_supervisor: fn(recipient) -> {Chat.TaskSupervisor, recipient} end

Cree un archivo, config/test.exs y agregue:

# config/test.exs
use Mix.Config
config :chat, remote_supervisor: fn(_recipient) -> Chat.TaskSupervisor end


# Recuerde descomentar esta línea en config/config.exs:

use Mix.Config
import_config "#{Mix.env()}.exs"

# Por último, actualizaremos nuestra función Chat.remote_supervisor/1 para buscar y usar la función almacenada en nuestra nueva variable de aplicación:

# lib/chat.ex
defp remote_supervisor(recipient) do
  Application.get_env(:chat, :remote_supervisor).(recipient)
end

# Conclusión

# Las capacidades de distribución nativas de Elixir, son gracias al poder de Erlang VM, es una de las características que la convierten en una herramienta tan poderosa. Podemos imaginarnos aprovechando la capacidad de Elixir para manejar la computación distribuida para ejecutar trabajos en segundo plano concurrentes, para admitir aplicaciones de alto rendimiento, para ejecutar operaciones costosas, lo que sea.

# Esta lección nos brinda una introducción básica al concepto de distribución en Elixir y le brinda las herramientas que necesita para comenzar a construir aplicaciones distribuidas. Mediante el uso de tareas supervisadas, puede enviar mensajes a través de los distintos nodos de una aplicación distribuida.
