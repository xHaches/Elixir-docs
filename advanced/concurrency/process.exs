# Uno de los puntos de venta de Elixir es su compatibilidad con la concurrencia. Gracias a Erlang VM (BEAM), la concurrencia en Elixir es más fácil de lo esperado. El modelo de concurrencia se basa en Actores, un proceso contenido que se comunica con otros procesos a través del paso de mensajes.

# En esta lección, veremos los módulos de concurrencia que se incluyen con Elixir. En el siguiente capítulo cubrimos los comportamientos de OTP que los implementan.

# Procesos
# Los procesos en Erlang VM son livianos y se ejecutan en todas las CPU. Si bien pueden parecer subprocesos nativos, son más simples y no es raro tener miles de procesos concurrentes en una aplicación Elixir.

# La forma más sencilla de crear un nuevo proceso es spawn, que requiere una función anónima o con nombre. Cuando creamos un nuevo proceso, devuelve un Identificador de proceso, o PID, para identificarlo de forma única dentro de nuestra aplicación.

# Para comenzar, crearemos un módulo y definiremos una función que nos gustaría ejecutar:

defmodule Example do
  def add(a, b) do
    IO.puts(a + b)
  end
end

iex > Example.add(2, 3)
5
:ok

# Para evaluar la función asíncronamente se usa spawn/3
iex > spawn(Example, :add, [2, 3])
5
# PID<0.80.0>
