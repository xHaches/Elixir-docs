# Un servidor OTP es un módulo con el comportamiento(behavior) de GenServer que implementa un conjunto de devoluciones de llamada. En su nivel más básico, un GenServer es un proceso único que ejecuta un bucle que maneja un mensaje por iteración pasando por un estado actualizado.

# Para demostrar la API de GenServer, implementaremos una cola básica para almacenar y recuperar valores.

# Para comenzar nuestro GenServer necesitamos iniciarlo y manejar la inicialización. En la mayoría de los casos, queremos vincular procesos, por lo que usamos GenServer.start_link/3. Pasamos el módulo GenServer que estamos iniciando, los argumentos iniciales y un conjunto de opciones de GenServer. Los argumentos se pasarán a GenServer.init/1 que establece el estado inicial a través de su valor de retorno. En nuestro ejemplo, los argumentos serán nuestro estado inicial:

defmodule SimpleQueue do
  use GenServer

  @doc """
  Start our queue and link it.
  This is a helper function
  """
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  GenServer.init/1 callback
  """
  def init(state), do: {:ok, state}
end
