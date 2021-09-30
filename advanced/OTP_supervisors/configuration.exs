# Supervisores

# La magia de los supervisores está en la función Supervisor.start_link/2. Además de iniciar a nuestro supervisor y a los hijos(children), nos permite definir la estrategia que nuestro supervisor usa para administrar los procesos de los hijos.

# Con SimpleQueue de la lección de simultaneidad de OTP, comencemos:

# Cree un nuevo proyecto usando:

$ mix new simple_queue --sup

# para crear un nuevo proyecto con un árbol de supervisores. El código para el módulo SimpleQueue debe ir en lib/simple_queue.ex y el código de supervisor que agregaremos irá en lib/simple_queue/application.ex

# Los hijos se definen mediante una lista, ya sea una lista de nombres de módulo:

defmodule SimpleQueue.Application do
  use Application

  def start(_type, _args) do
    children = [
      SimpleQueue
    ]

    opts = [strategy: :one_for_one, name: SimpleQueue.Supervisor]
    Supervisor.start_link(children, opts)
  end
end


# o una lista de tuplas si desea incluir opciones de configuración:

defmodule SimpleQueue.Application do
  use Application

  def start(_type, _args) do
    children = [
      {SimpleQueue, [1,2,3]}
    ]

    opts = [strategy: :one_for_one, name: SimpleQueue.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# Si ejecutamos

$ iex -S mix

# veremos que nuestro SimpleQueue se inicia automáticamente:
iex> SimpleQueue.queue
[1, 2, 3]

# Si nuestro proceso SimpleQueue fallara o terminara, nuestro Supervisor lo reiniciaría automáticamente como si nada hubiera sucedido.

# Estrategias
# Actualmente hay tres estrategias de supervisión diferentes disponibles para los supervisores:

# :one_for_one solo reinicia el proceso hijo fallido.

# :one_for_all reinicia todos los procesos secundarios en caso de falla.

# :rest_for_one reinicia el proceso fallido y cualquier proceso iniciado después de él.

# Especificación de hijos
# Una vez que el supervisor ha iniciado, debe saber cómo iniciar/detener/reiniciar a sus hijos. Cada módulo hijo debe tener una función child_spec/1 para definir estos comportamientos. las macros 'use GenServer', el 'use Supervisor' y 'use Agent' definen automáticamente este método para nosotros (SimpleQueue ha usado Genserver, por lo que no necesitamos modificar el módulo), pero si necesita definirlo usted mismo child_spec/1 debería devolver un mapa de opciones:

def child_spec(opts) do
  %{
    id: SimpleQueue,
    start: {__MODULE__, :start_link, [opts]},
    shutdown: 5_000,
    restart: :permanent,
    type: :worker
  }
end

# id clave requerida. Utilizado por el supervisor para identificar la especificación del hijo.

# start clave requerida. El módulo / función / argumentos para llamar cuando lo inicia el supervisor

# shutdown - Llave opcional. Define el comportamiento del hijo durante el apagado. Las opciones son:

#   :brutal_kill - El niño se detiene inmediatamente

# cualquier entero positivo - tiempo en milisegundos que esperará el supervisor antes de matar el proceso hijo. Si el proceso es un tipo :worker, este valor predeterminado es 5000.

# :infinity - el supervisor esperará indefinidamente antes de eliminar el proceso secundario. Predeterminado para: tipo de proceso :supervisor No recomendado para: tipo :worker

# restart clave opcional. Hay varios enfoques para manejar los bloqueos de procesos secundarios:

# :permanent el niño siempre se reinicia. Predeterminado para todos los procesos

# :temporary el proceso hijo nunca se reinicia.

# :transient el proceso hijo se reinicia solo si finaliza de forma anormal.

# type clave opcional. Los procesos pueden ser :worker o :supervisor. El valor predeterminado es :worker

# DynamicSupervisor

# Los supervisores normalmente comienzan con una lista de hijos para comenzar cuando se inicia la aplicación. Sin embargo, a veces no se conocerá a los hijos supervisados ​​cuando se inicie nuestra aplicación (por ejemplo, es posible que tengamos una aplicación web que inicie un nuevo proceso para manejar a un usuario que se conecta a nuestro sitio). Para estos casos, necesitaremos un supervisor donde los hijos puedan iniciarse a pedido. El DynamicSupervisor se utiliza para manejar este caso.

# Dado que no especificaremos hijos, solo necesitamos definir las opciones de tiempo de ejecución para el supervisor. DynamicSupervisor solo admite la estrategia de supervisión :one_for_one

options = [
  name: SimpleQueue.Supervisor,
  strategy: :one_for_one
]

DynamicSupervisor.start_link(options)

# Luego, para iniciar un nuevo SimpleQueue dinámicamente, usaremos start_child/2 que toma un supervisor y la especificación del hijo (nuevamente, SimpleQueue usa use GenServer, por lo que la especificación secundaria ya está definida):

# Task Supervisor

# Las tareas tienen su propio supervisor especializado, el Task.Supervisor. Diseñado para tareas creadas dinámicamente, el supervisor usa DynamicSupervisor en el fondo.

# Configuración

# Incluyendo el Task.Supervisor no es diferente a otros supervisores

children = [
  {Task.Supervisor, name: ExampleApp.TaskSupervisor, restart: :transient}
]

{:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)

# La principal diferencia entre Supervisor y Task.Supervisor es que su estrategia de reinicio predeterminada es :temporary (las tareas nunca se reiniciarían).

# Tareas supervisadas

# Con el supervisor iniciado, podemos usar la función start_child/2 para crear una tarea supervisada:

{:ok, pid} = Task.Supervisor.start_child(ExampleApp.TaskSupervisor, fn -> background_work end)

# Si nuestra tarea falla prematuramente, se reiniciará. Esto puede resultar particularmente útil cuando se trabaja con conexiones entrantes o se procesa trabajo en segundo plano.
