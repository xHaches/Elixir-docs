# Tal como el nombre sugiere, una función anónima no tiene nombre. Como vimos en la lección Enum, son pasadas frecuentemente a otras funciones. Para definir una función anónima en Elixir necesitamos las palabras clave fn y end. Dentro de estos podemos definir, separados por ->, cualquier número de parámetros y el cuerpo de la función.

sum = fn a, b -> a + b end
sum.(2, 3)
# 5

# Operador capture (&)
# Usar funciones anónimas es una práctica común en Elixir, hay un atajo para hacer esto:
sum = &(&1 + &2)
sum.(2, 3)
# 5

# Como probablemente ya has adivinado, en la versión reducida nuestros parámetros están disponibles como: &1, &2, &3...

# Pattern matching en funciones
# La coincidencia de patrones no está limitada solo a las variables en Elixir, puede ser aplicada a las firmas de la función como veremos en esta sección.

# Elixir usa coincidencia de patrones para identificar el primer conjunto de parámetros que coincidan e invocar al cuerpo correspondiente:

handle_result = fn
  {:ok, result} -> IO.puts("Handling result...")
  {:ok, _} -> IO.puts("This would be never run as previous will be matched beforehand.")
  {:error} -> IO.puts("An error has occurred!")
end

some_result = 1
handle_result.({:ok, some_result})
# Handling result...
:ok
handle_result.({:error})
# An error has occurred!
