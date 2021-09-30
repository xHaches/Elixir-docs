# Process Linking

# Un problema con el spawn es saber cuándo falla un proceso. Para eso necesitamos vincular nuestros procesos usando spawn_link. Dos procesos vinculados recibirán notificaciones de salida entre sí:

defmodule Example do
  def explode, do: exit(:kaboom)
end

iex> spawn(Example, :explode, [])
#PID<0.66.0>

iex> spawn_link(Example, :explode, [])
** (EXIT from #PID<0.57.0>) evaluator process exited with reason: :kaboom

# A veces, no queremos que nuestro proceso vinculado bloquee el actual. Para eso, necesitamos atrapar las salidas usando Process.flag/2. La cual utiliza la función process_flag/2 de erlang para la bandera trap_exit. Cuando se capturan salidas (trap_exit se establece en verdadero), las señales de salida se recibirán como un mensaje de tupla: {:EXIT, from_pid, reason}.

defmodule Example do
  def explode, do: exit(:kaboom)

  def run do
    Process.flag(:trap_exit, true)
    spawn_link(Example, :explode, [])

    receive do
      {:EXIT, _from_pid, reason} -> IO.puts("Exit reason: #{reason}")
    end
  end
end

iex> Example.run
Exit reason: kaboom
:ok
