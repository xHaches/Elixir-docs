# En esta lección, analizaremos más de cerca el GenStage, qué función cumple y cómo podemos aprovecharlo en nuestras aplicaciones.

# Entonces, ¿qué es GenStage? De la documentación oficial, es una "especificación y flujo computacional para Elixir", pero ¿qué significa eso para nosotros?

# Lo que significa es que GenStage nos proporciona una forma de definir una línea de trabajo que se llevará a cabo mediante pasos (o etapas) independientes en procesos separados; Si ha trabajado con pipelines antes, algunos de estos conceptos deberían resultarle familiares.

# Para comprender mejor cómo funciona esto, visualicemos un flujo simple de productor-consumidor (producer-consumer):

[A] -> [B] -> [C]

# En este ejemplo tenemos tres etapas: A un productor, B un productor-consumidor y C un consumidor. A produce un valor que es consumido por B, B realiza algún trabajo y devuelve un nuevo valor que es recibido por nuestro consumidor C; el papel de nuestro escenario es importante como veremos en la siguiente sección.

# Si bien nuestro ejemplo es de productor a consumidor 1 a 1, es posible tener múltiples productores y múltiples consumidores en cualquier etapa determinada.

# Para ilustrar mejor estos conceptos, construiremos una canalización con GenStage, pero primero exploremos un poco más las funciones en las que se basa GenStage.

# Consumers and Producers

# Como hemos leído, el papel que le damos a nuestro escenario es importante. La especificación GenStage reconoce tres roles:

# :producer  - una fuente. Los productores esperan la demanda de los consumidores y responden con los eventos solicitados.

# :producer_consumer - fuente y consumidor. Los productores-consumidores pueden responder a la demanda de otros consumidores, así como solicitar eventos a los productores.

# :consumer - Un consumidor. Un consumidor solicita y recibe datos de los productores.

# ¿Observa que nuestros productores esperan la demanda? Con GenStage, nuestros consumidores envían la demanda río arriba y procesan los datos de nuestro productor. Esto facilita un mecanismo conocido como contrapresión. La contrapresión impone al productor la responsabilidad de no presionar demasiado cuando los consumidores están ocupados.

# Ahora que hemos cubierto los roles dentro de GenStage, comencemos con nuestra aplicación.

# Iniciar app

# En este ejemplo, construiremos una aplicación GenStage que emite números, clasifica los números pares y finalmente los imprime.

# Para nuestra aplicación, usaremos los tres roles de GenStage. Nuestro productor se encargará de contar y emitir números. Usaremos un producer-consumer para filtrar solo los números pares y luego responder a la demanda de la cadena descendente. Por último, crearemos un consumer que nos muestre los números restantes.

# Comenzaremos generando un proyecto con un árbol de supervisión:

$ mix new genstage_example --sup
$ cd genstage_example

# actualizar dependencias en mix.exs para incluir gen_stage
defp deps do
  [
    {:gen_stage, "~> 1.0.0"},
  ]
end

# Deberíamos buscar nuestras dependencias y compilar antes de ir mucho más allá:

$ mix do deps.get, compile

# Ahora estamos listos para construir nuestro producer

# -------------------------- producer -----------------------------

# El primer paso de nuestra aplicación GenStage es crear nuestro productor. Como comentamos antes, queremos crear un productor que emita un flujo constante de números. Creemos nuestro archivo de productor:

$ touch lib/genstage_example/producer.ex

defmodule GenstageExample.Producer do
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    events = Enum.to_list(state..(state + demand - 1))
    {:noreply, events, state + demand}
  end
end

# Las dos partes más importantes a tener en cuenta aquí son init/1 y handle_demand/2. En init/1 establecemos el estado inicial como lo hemos hecho en nuestros GenServers, pero lo más importante es que nos etiquetamos como productores. La respuesta de nuestra función init/1 es en lo que se basa GenStage para clasificar nuestro proceso.

# La función handle_demand/2 es donde se define la mayoría de nuestro productor. Debe ser implementado por todos los productores de GenStage. Aquí devolvemos el conjunto de números exigidos por nuestros consumidores e incrementamos nuestro contador. La demanda de los consumidores, demanda en nuestro código anterior, se representa como un número entero correspondiente al número de eventos que pueden manejar; por defecto es 1000.

# ----------------------------- producer-consumer -----------------------------

# Ahora que tenemos un producer generador de números, pasemos a nuestro producer-consumer. Querremos solicitar números a nuestro productor, filtrar el que no sea y responder a la demanda.

$ touch lib/genstage_example/producer_consumer.ex

defmodule GenstageExample.ProducerConsumer do
  use GenStage

  require Integer

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state_doesnt_matter, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [GenstageExample.Producer]}
  end

  def handle_events(events, _from, state) do
    numbers =
      events
      |> Enum.filter(&Integer.is_even/1)

    {:noreply, numbers, state}
  end
end


# Es posible que haya notado que con nuestro producer-consumer hemos introducido una nueva opción en init/1 y una nueva función: handle_events/3. Con la opción subscribe_to, le indicamos a GenStage que nos ponga en comunicación con un productor específico.

# La función handle_events/3 es nuestro caballo de batalla, donde recibimos nuestros eventos entrantes, los procesamos y devolvemos nuestro conjunto transformado. Como veremos, los consumidores se implementan de la misma manera, pero la diferencia importante es lo que devuelve nuestra función handle_events/3 y cómo se usa. Cuando etiquetamos nuestro proceso como producer_consumer, el segundo argumento de nuestra tupla, numbers en nuestro caso, se utiliza para satisfacer la demanda de los consumidores posteriores. En los consumidores se descarta este valor.

# consumer

$ touch lib/genstage_example/consumer.ex

# Dado que los consumidores y los producer-consumer son tan similares, nuestro código no se verá muy diferente:

defmodule GenstageExample.Consumer do
  use GenStage

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state_doesnt_matter)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [GenstageExample.ProducerConsumer]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect({self(), event, state})
    end

    # As a consumer we never emit events
    {:noreply, [], state}
  end
end

# Como cubrimos en la sección anterior, nuestro consumidor no emite eventos, por lo que se descartará el segundo valor de nuestra tupla.

# Juntándolo todo

# Ahora que tenemos nuestro producer, producer-consumer y consumer construido, estamos listos para conectar todo.

# Comencemos abriendo lib/genstage_example/application.ex y agregando nuestros nuevos procesos al árbol de supervisores:

def start(_type, _args) do
  import Supervisor.Spec, warn: false

  children = [
    {GenstageExample.Producer, 0},
    {GenstageExample.ProducerConsumer, []},
    {GenstageExample.Consumer, []}
  ]

  opts = [strategy: :one_for_one, name: GenstageExample.Supervisor]
  Supervisor.start_link(children, opts)
end

# Si todo está bien, podemos ejecutar nuestro proyecto y deberíamos ver que todo funciona:

$ mix run --no-halt
{#PID<0.109.0>, 0, :state_doesnt_matter}
{#PID<0.109.0>, 2, :state_doesnt_matter}
{#PID<0.109.0>, 4, :state_doesnt_matter}
{#PID<0.109.0>, 6, :state_doesnt_matter}
...
{#PID<0.109.0>, 229062, :state_doesnt_matter}
{#PID<0.109.0>, 229064, :state_doesnt_matter}
{#PID<0.109.0>, 229066, :state_doesnt_matter}

# ¡Lo hicimos! Como esperábamos, nuestra aplicación solo emite números pares y lo hace rápidamente.

# En este punto tenemos una tubería(pipeline) en funcionamiento. Hay un producer que emite números, un producer-consumer que descarta números impares y un consumer que muestra todo esto y continúa el flujo.

# múltiples producers o consumers

# Mencionamos en la introducción que era posible tener más de un producer o consumer. Echemos un vistazo a eso.

# Si examinamos la salida IO.inspect/1 de nuestro ejemplo, vemos que cada evento es manejado por un solo PID. Hagamos algunos ajustes para varios workers modificando lib/genstage_example/application.ex:

children = [
  {GenstageExample.Producer, 0},
  {GenstageExample.ProducerConsumer, []},
  %{
    id: 1,
    start: {GenstageExample.Consumer, :start_link, [[]]}
  },
  %{
    id: 2,
    start: {GenstageExample.Consumer, :start_link, [[]]}
  },
]

# Ahora que hemos configurado dos consumidores, veamos qué obtenemos si ejecutamos nuestra aplicación ahora:

$ mix run --no-halt
{#PID<0.120.0>, 0, :state_doesnt_matter}
{#PID<0.120.0>, 2, :state_doesnt_matter}
{#PID<0.120.0>, 4, :state_doesnt_matter}
{#PID<0.120.0>, 6, :state_doesnt_matter}
...
{#PID<0.120.0>, 86478, :state_doesnt_matter}
{#PID<0.121.0>, 87338, :state_doesnt_matter}
{#PID<0.120.0>, 86480, :state_doesnt_matter}
{#PID<0.120.0>, 86482, :state_doesnt_matter}


# Como puede ver, ahora tenemos varios PID, simplemente agregando una línea de código y dando las identificaciones de nuestros consumidores.

# ---------------------- casos de uso --------------------
# Canalización de transformación de datos: los productores no tienen que ser simples generadores de números. Podríamos producir eventos a partir de una base de datos o incluso de otra fuente como Kafka de Apache. Con una combinación de producers-consumers y consumers, podríamos procesar, clasificar, catalogar y almacenar métricas a medida que estén disponibles.

# Cola de trabajo: dado que los eventos pueden ser cualquier cosa, podríamos producir unidades de trabajo para ser completadas por una serie de consumidores.

# Procesamiento de eventos: similar a una canalización de datos, podríamos recibir, procesar, clasificar y tomar medidas sobre eventos emitidos en tiempo real desde nuestras fuentes.
