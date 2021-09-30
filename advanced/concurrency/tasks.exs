# Tarea - Task

# Las tareas proporcionan una forma de ejecutar una función en segundo plano y recuperar su valor de retorno más tarde. Pueden ser particularmente útiles cuando se manejan operaciones costosas sin bloquear la ejecución de la aplicación.

defmodule Example do
  def double(x) do
    :timer.sleep(2000)
    x * 2
  end
end

iex> task = Task.async(Example, :double, [2000])
%Task{
  owner: #PID<0.105.0>,
  pid: #PID<0.114.0>,
  ref: #Reference<0.2418076177.4129030147.64217>
}

# Do some work

iex> Task.await(task)
4000
