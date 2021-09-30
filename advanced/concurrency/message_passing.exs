# Intercambio de mensajes
# Para comunicarse, los procesos se basan en el paso de mensajes. Hay dos componentes principales para esto: send/2 y recieve. La función send/2 nos permite enviar mensajes a PID. Para escuchar usamos recieve para hacer coincidir los mensajes. Si no se encuentra ninguna coincidencia, la ejecución continúa sin interrupciones.

defmodule Example do
  def listen do
    receive do
      {:ok, "hello"} -> IO.puts("World")
    end

    listen()
  end
end

iex > pid = spawn(Example, :listen, [])
# PID<0.108.0>

iex > send(pid, {:ok, "hello"})
World
{:ok, "hello"}

iex > send(pid, :ok)
:ok

# Puede notar que la función listen/0 es recursiva, esto permite que nuestro proceso maneje múltiples mensajes. Sin recursividad, nuestro proceso saldría después de manejar el primer mensaje.
