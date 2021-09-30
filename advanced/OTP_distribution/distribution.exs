# Comunicación entre nodos

# Elixir corre encima de Erlang VM, lo cual quiere decir que tiene acceso a la funcionalidad distribuida https://erlang.org/doc/reference_manual/distributed.html

# Un sistema Erlang distribuido consta de varios sistemas de ejecución de Erlang que se comunican entre sí. Cada uno de estos sistemas de tiempo de ejecución se denomina nodo.

# Un nodo es cualquier sistema de ejecución de Erlang al que se le ha dado un nombre. Podemos iniciar un nodo abriendo la sesión iex y nombrándolo:

$ iex --sname alex@localhost
iex(alex@localhost)>

# Abramos otro nodo en otra ventana de terminal:

iex --sname kate@localhost
iex(kate@localhost)>

# Estos dos nodos pueden enviarse mensajes entre sí mediante Node.spawn_link/2.
# Comunicando con Node.spawn_link/2

# La función toma dos argumentos.
# El nombre del nodo al cual quieres conectarte
# La función que ejecutará el proceso remoto que se ejecuta en ese nodo

# Establece la conexión con el nodo remoto y ejecuta la función dada en ese nodo, devolviendo el PID del proceso vinculado.

# Definamos un módulo, Kate, en el nodo kate que sepa cómo presentar a Kate, la persona:

iex(kate@localhost)> defmodule Kate do
...(kate@localhost)>   def say_name do
...(kate@localhost)>     IO.puts "Hi, my name is Kate"
...(kate@localhost)>   end
...(kate@localhost)> end

# Enviando mensajes

# Ahora, podemos usar Node.spawn_link/2 para que el nodo alex le pida al nodo kate que llame a la función say_name/0:

iex(alex@localhost)> Node.spawn_link(:kate@localhost, fn -> Kate.say_name end)
Hi, my name is Kate
#PID<10507.132.0>

# Una nota sobre I/O y nodos
# Tenga en cuenta que, aunque Kate.say_name/0 se está ejecutando en el nodo remoto, es el nodo local o llamante el que recibe la salida IO.puts. Eso es porque el nodo local es el líder del grupo. Erlang VM gestiona la I/O a través de procesos. Esto nos permite ejecutar tareas de I/O, como entradas de I/O, en nodos distribuidos. Estos procesos distribuidos son administrados por el líder del grupo de procesos de I/O. El líder del grupo es siempre el nodo que genera el proceso. Entonces, dado que nuestro nodo alex es el que llamamos spawn_link/2, ese nodo es el líder del grupo y la salida de IO.puts se dirigirá al flujo de salida estándar de ese nodo.

# Respondiendo a mensajes

# ¿Qué pasa si queremos que el nodo que recibe el mensaje envíe alguna respuesta al remitente? Podemos usar una configuración simple de recibir/1 y enviar/3 para lograr exactamente eso.

# Haremos que nuestro nodo alex genere un enlace al nodo kate y le dé al nodo kate una función anónima para ejecutar. Esa función anónima escuchará la recepción de una tupla particular que describe un mensaje y el PID del nodo alex. Responderá a ese mensaje enviando(send) un mensaje al PID del nodo alex:

iex(alex@localhost)> pid = Node.spawn_link :kate@localhost, fn ->
...(alex@localhost)>   receive do
...(alex@localhost)>     {:hi, alex_node_pid} -> send alex_node_pid, :sup?
...(alex@localhost)>   end
...(alex@localhost)> end
#PID<10467.112.0>
iex(alex@localhost)> pid
#PID<10467.112.0>
iex(alex@localhost)> send(pid, {:hi, self()})
{:hi, #PID<0.106.0>}
iex(alex@localhost)> flush()
:sup?
:ok

# Una nota sobre la comunicación entre nodos en diferentes redes

# Si desea enviar mensajes entre nodos en diferentes redes, necesitamos iniciar los nodos nombrados con una cookie compartida:

$ iex --sname alex@localhost --cookie secret_token

$ iex --sname kate@localhost --cookie secret_token

# Solo los nodos que se inicien con la misma cookie podrán conectarse correctamente entre sí.

# Limitaciones de Node.spawn_link/2

# Si bien Node.spawn_link/2 ilustra las relaciones entre los nodos y la forma en que podemos enviar mensajes entre ellos, no es realmente la elección correcta para una aplicación que se ejecutará en nodos distribuidos. Node.spawn_link/2 genera procesos de forma aislada, es decir, procesos que no están supervisados. Si tan solo hubiera una forma de generar procesos asincrónicos supervisados ​​en todos los nodos...

# Tasks distribuídas

# Las tareas distribuídas nos permiten generar(spawn) tareas(tasks) supervisadas en todos los nodos. Crearemos una aplicación de supervisor simple que aprovecha las tareas distribuidas para permitir que los usuarios conversen entre sí a través de una sesión iex, a través de nodos distribuidos.

# Definiendo la aplicación de supervisión
# Genera la app
$ mix new chat --sup

Agregar el supervisor de tareas al árbol de supervisión
# Un supervisor de tareas supervisa las tareas de forma dinámica. Se inicia sin hijos, a menudo bajo un supervisor propio, y se puede usar más adelante para supervisar cualquier cantidad de tareas.

# Agregaremos un supervisor de tareas al árbol de supervisión de nuestra aplicación y lo llamaremos Chat.TaskSupervisor

# lib/chat/application.ex
defmodule Chat.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Chat.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Chat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# Ahora sabemos que donde sea que se inicie nuestra aplicación en un nodo determinado, el Supervisor de Chat se está ejecutando y listo para supervisar las tareas.

# Envío de mensajes con tareas supervisadas

# Iniciamos tareas supervisadas con la función Task.Supervisor.async/5
# Esta función debe tener cuatro argumentos:

# - El supervisor que queremos usar para supervisar la tarea, puede ser pasado a través de una tupla de {SupervisorName, remote_node_name} para supervisar la tarea en el nodo remoto.
# - El nombre del módulo donde queremos ejecutar la función
# - El nombre de la función que queremos ejecutar
# - Cualquier argumento que deba proporcionarse a esa función

# Puede pasar un quinto argumento opcional que describa las opciones de apagado. No nos preocuparemos por eso aquí.

# Nuestra aplicación de chat es bastante simple. Envía mensajes a los nodos remotos y los nodos remotos responden a esos mensajes IO.puts-ing al STDOUT del nodo remoto.

# Primero, definimos una función, Chat.recieve_message/1, que queremos que nuestra tarea se ejecute en un nodo remoto.

# lib/chat.ex
defmodule Chat do
  def receive_message(message) do
    IO.puts message
  end
end

# A continuación, enseñamos al módulo Chat cómo enviar el mensaje a un nodo remoto mediante una tarea supervisada. Definiremos un método Chat.send_message/2 que ejecutará este proceso:

# lib/chat.ex
defmodule Chat do
  ...

  def send_message(recipient, message) do
    spawn_task(__MODULE__, :receive_message, recipient, [message])
  end

  def spawn_task(module, fun, recipient, args) do
    recipient
    |> remote_supervisor()
    |> Task.Supervisor.async(module, fun, args)
    |> Task.await()
  end

  defp remote_supervisor(recipient) do
    {Chat.TaskSupervisor, recipient}
  end
end

# Veámoslo en acción:
# En una ventana de la terminal, iniciamos nuetra app chat en una sesión iex con nombre

$ iex --sname alex@localhost -S mix

# Abra otra ventana de terminal para iniciar la aplicación en un nodo con nombre diferente:

iex --sname kate@localhost -S mix

# Ahora, desde el nodo alex, podemos enviarle un mensaje al nodo kate:

iex(alex@localhost)> Chat.send_message(:kate@localhost, "hi")
:ok

# Cambie a la ventana de kate y debería ver el mensaje:
iex(kate@localhost)> hi

# El nodo kate puede responder al nodo alex:

iex(kate@localhost)> hi
Chat.send_message(:alex@localhost, "how are you?")
:ok
iex(kate@localhost)>

# Y se mostrará en la sesión iex del nodo alex:

iex(alex@localhost)> how are you?

# Revisemos nuestro código y analicemos lo que está sucediendo aquí.

# Tenemos una función Chat.send_message/2 que toma el nombre del nodo remoto en el que queremos ejecutar nuestras tareas supervisadas y el mensaje que queremos enviar a ese nodo.

# Esa función llama a nuestra función spawn_task/4 que inicia una tarea asíncrona que se ejecuta en el nodo remoto con el nombre dado, supervisada por Chat.TaskSupervisor en ese nodo remoto. Sabemos que el supervisor de tareas con el nombre Chat.TaskSupervisor se está ejecutando en ese nodo porque ese nodo también está ejecutando una instancia de nuestra aplicación Chat y el Chat.TaskSupervisor se inicia como parte del árbol de supervisión de la aplicación Chat.

# Le estamos diciendo al Chat.TaskSupervisor que supervise una tarea que ejecuta la función Chat.receive_message con un argumento de cualquier mensaje que se haya transmitido a spawn_task/4 desde send_message/2.

# Entonces, se llama a Chat.receive_message("hi") en el nodo remoto, kate, lo que hace que el mensaje "hola" se envíe al flujo STDOUT de ese nodo. En este caso, dado que la tarea se supervisa en el nodo remoto, ese nodo es el administrador de grupo para este proceso de I/O.

# Respondiendo a mensajes desde nodos remotos

# Hagamos nuestra aplicación Chat un poco más inteligente. Hasta ahora, cualquier número de usuarios puede ejecutar la aplicación en una sesión iex con nombre y comenzar a chatear. Pero digamos que hay un perro blanco de tamaño mediano llamado Moebi que no quiere quedarse fuera. Moebi quiere ser incluido en la aplicación Chat pero lamentablemente no sabe escribir porque es un perro. Por lo tanto, enseñaremos a nuestro módulo de chat a responder a cualquier mensaje enviado a un nodo llamado moebi@localhost en nombre de Moebi. No importa lo que le digas a Moebi, él responderá con "¿pollo?", Porque su único deseo verdadero es comer pollo.

# Definiremos otra versión de nuestra función send_message/2 que el patrón coincide con el argumento del destinatario. Si el destinatario es :moebi@locahost, lo haremos

# Toma el nombre del nodo actual usando Node.self()
# Dé el nombre del nodo actual, es decir, el remitente, a una nueva función Receive_message_for_moebi/2, para que podamos enviar un mensaje de regreso a ese nodo.

# lib/chat.ex
...
def send_message(:moebi@localhost, message) do
  spawn_task(__MODULE__, :receive_message_for_moebi, :moebi@localhost, [message, Node.self()])
end

# A continuación, definiremos una función Receive_message_for_moebi/2 que IO muestra el mensaje en el flujo STDOUT del nodo moebi y envía un mensaje al remitente:

# lib/chat.ex
...
def receive_message_for_moebi(message, from) do
  IO.puts message
  send_message(from, "chicken?")
end

# Al llamar a send_message/2 con el nombre del nodo que envió el mensaje original (el "nodo remitente") le estamos diciendo al nodo remoto que genere una tarea supervisada en ese nodo remitente.

# Veámoslo en acción. En tres ventanas de terminal diferentes, abra tres nodos con nombre diferentes:

iex --sname alex@localhost -S mix

iex --sname kate@localhost -S mix

iex --sname moebi@localhost -S mix

# Dejemos que alex envíe un mensaje a moebi:

iex(alex@localhost)> Chat.send_message(:moebi@localhost, "hi")
chicken?
:ok

# Podemos ver que el nodo alex recibió la respuesta, "¿pollo?". Si abrimos el nodo kate, veremos que no se recibió ningún mensaje, ya que ni alex ni moebi le envían uno (lo siento kate). Y si abrimos la ventana de terminal del nodo moebi, veremos el mensaje que envió el nodo alex:

iex(moebi@localhost)> hi
