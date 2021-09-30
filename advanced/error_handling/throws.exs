# Throws
# Otro mecanismo para trabajar con errores en Elixir es throw y catch. En la práctica, estos ocurren con muy poca frecuencia en el código Elixir más nuevo, pero es importante conocerlos y comprenderlos de todos modos.

# La función throw / 1 nos da la capacidad de salir de la ejecución con un valor específico que podemos capturar y usar:

try do
  for x <- 0..10 do
    if x == 5, do: throw(x)
    IO.puts(x)
  end
catch
  x -> "Caught: #{x}"
end

0
1
2
3
4

"Caught: 5"

# Como se mencionó, throw/catch son bastante poco comunes y, por lo general, existen como provisiones cuando las bibliotecas no brindan las API adecuadas.

# Exiting
# El mecanismo de error final que nos proporciona Elixir es exit. Las señales de salida ocurren cada vez que un proceso muere y son una parte importante de la tolerancia a fallas de Elixir.

# Para salir explícitamente podemos usar exit/1:
iex> spawn_link fn -> exit("oh no") end
** (EXIT from #PID<0.101.0>) evaluator process exited with reason: "oh no"

# Si bien es posible atrapar una salida con try/catch, hacerlo es extremadamente raro. En casi todos los casos, es ventajoso dejar que el supervisor maneje la salida del proceso:
try do
  exit "Oh no"
catch
  :exit, _ -> "exit blocked"
end
"exit blocked"
