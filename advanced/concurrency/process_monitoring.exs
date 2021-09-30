# Monitoreo de procesos
# ¿Qué pasa si no queremos vincular dos procesos pero aún así nos mantenemos informados? Para eso podemos usar el monitoreo de procesos con spawn_monitor. Cuando monitoreamos un proceso, recibimos un mensaje si el proceso falla sin que nuestro proceso actual se bloquee o necesite atrapar salidas explícitamente.

defmodule Example do
  def explode, do: exit(:kaboom)

  def run do
    spawn_monitor(Example, :explode, [])

    receive do
      {:DOWN, _ref, :process, _from_pid, reason} -> IO.puts("Exit reason: #{reason}")
    end
  end
end

iex> Example.run
Exit reason: kaboom
:ok
