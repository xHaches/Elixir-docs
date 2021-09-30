# funciones síncronas
# A menudo es necesario interactuar con GenServers de forma síncrona, llamando a una función y esperando su respuesta. Para manejar solicitudes síncronas, necesitamos implementar la devolución de llamada GenServer.handle_call/3 que toma: la solicitud, el PID de la persona que llama y el estado existente; se espera que responda devolviendo una tupla: {:reply, response, state}.

# Con pattern matching podemos definir devoluciones de llamada para muchas solicitudes y estados diferentes. Puede encontrar una lista completa de valores de retorno aceptados en docs GenServer.handle_call/3.

# Para demostrar las solicitudes síncronas, agreguemos la capacidad de mostrar nuestra cola actual y eliminar un valor:

defmodule SimpleQueue do
  use GenServer

  ### GenServer API

  @doc """
  GenServer.init/1 callback
  """
  def init(state), do: {:ok, state}

  @doc """
  GenServer.handle_call/3 callback
  """
  def handle_call(:dequeue, _from, [value | state]) do
    {:reply, value, state}
  end

  def handle_call(:dequeue, _from, []), do: {:reply, nil, []}

  def handle_call(:queue, _from, state), do: {:reply, state, state}

  ### Client API / Helper functions

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def queue, do: GenServer.call(__MODULE__, :queue)
  def dequeue, do: GenServer.call(__MODULE__, :dequeue)
end

iex> SimpleQueue.start_link([1, 2, 3])
{:ok, #PID<0.90.0>}
iex> SimpleQueue.dequeue
1
iex> SimpleQueue.dequeue
2
iex> SimpleQueue.queue
[3]
