# Enum: conjuto de algortimos para trabajar con colecciones

Enum.__info__(:functions)
|> Enum.each(fn {function, arity} ->
  IO.puts("#{function}/#{arity}")
end)

# all?/1
# all?/2
# any?/1
# any?/2
# at/2
# at/3
# chunk/2
# chunk/3
# chunk/4
# chunk_by/2
# chunk_every/2
# chunk_every/3
# chunk_every/4
# chunk_while/4
# concat/1
# concat/2
# count/1
# count/2
# count_until/2
# count_until/3
# dedup/1
# dedup_by/2
# drop/2
# drop_every/2
# drop_while/2
# each/2
# empty?/1
# fetch/2
# fetch!/2
# filter/2
# filter_map/3
# find/2
# find/3
# find_index/2
# find_value/2
# find_value/3
# flat_map/2
# flat_map_reduce/3
# frequencies/1
# frequencies_by/2
# group_by/2
# group_by/3
# intersperse/2
# into/2
# into/3
# join/1
# join/2
# map/2
# map_every/3
# map_intersperse/3
# map_join/2
# map_join/3
# map_reduce/3
# max/1
# max/2
# max/3
# max_by/2
# max_by/3
# max_by/4
# member?/2
# min/1
# min/2
# min/3
# min_by/2
# min_by/3
# min_by/4
# min_max/1
# min_max/2
# min_max_by/2
# min_max_by/3
# min_max_by/4
# partition/2
# product/1
# random/1
# reduce/2
# reduce/3
# reduce_while/3
# reject/2
# reverse/1
# reverse/2
# reverse_slice/3
# scan/2
# scan/3
# shuffle/1
# slice/2
# slice/3
# sort/1
# sort/2
# sort_by/2
# sort_by/3
# split/2
# split_while/2
# split_with/2
# sum/1
# take/2
# take_every/2
# take_random/2
# take_while/2
# to_list/1
# uniq/1
# uniq/2
# uniq_by/2
# unzip/1
# with_index/1
# with_index/2
# zip/1
# zip/2
# zip_reduce/3
# zip_reduce/4
# zip_with/2
# zip_with/3

# Cuando usas all?/2, y muchas de las funciones de Enum, proveemos una función para aplicar a los elementos de nuestra colección. En el caso de all?/2, la colección entera debe ser evaluada a true, en otro caso false será retornado:
length3 = Enum.all?(["foo", "bar", "hello"], fn s -> String.length(s) === 3 end)
IO.puts(length3)
# operador capture &
length3_capture = Enum.all?(["foo", "bar", "hello"], &(String.length(&1) === 3))
IO.puts(length3_capture)

# Diferente a lo anterior, any? retornará true si al menos un elemento es evaluado a true:
any_length3 = Enum.any?(["foo", "bar", "hello"], fn s -> String.length(s) === 3 end)
IO.puts(any_length3)
any_length3_capture = Enum.any?(["foo", "bar", "hello"], &(String.length(&1) === 3))
IO.puts(any_length3_capture)

# Enum.chunk_every
# Divide tu colección en pequeños grupos

# (coleccion, count, step, sobrante)
Enum.chunk_every([1, 2, 3, 4, 5, 6], 2)
[[1, 2], [3, 4], [5, 6]]

# si se envia :discard se omite el ultimo fragmento a menos que los elementos junten exactamente el ultimo fragmento
Enum.chunk_every([1, 2, 3, 4, 5, 6], 3, 2, :discard)
[[1, 2, 3], [3, 4, 5]]

Enum.chunk_every([1, 2, 3, 4, 5, 6], 3, 2, [7])
[[1, 2, 3], [3, 4, 5], [5, 6, 7]]

Enum.chunk_every([1, 2, 3, 4], 3, 3, [])
[[1, 2, 3], [4]]

Enum.chunk_every([1, 2, 3, 4], 10)
[[1, 2, 3, 4]]

Enum.chunk_every([1, 2, 3, 4, 5], 2, 3, [])
[[1, 2], [4, 5]]

# Enum.chunk_by
# Si necesitamos agrupar una colección basándose en algo diferente al tamaño, podemos usar la función chunk_by/2. Esta función recibe un enumerable como parámetro y una función, cada vez que la respuesta de esa función cambia un nuevo grupo es creado y continúa con la creación del siguiente:

Enum.chunk_by(["one", "two", "three", "four", "five"], fn x -> String.length(x) end)
Enum.chunk_by(["one", "two", "three", "four", "five"], &String.length(&1))
[["one", "two"], ["three"], ["four", "five"]]
Enum.chunk_by(["one", "two", "three", "four", "five", "six"], fn x -> String.length(x) end)
Enum.chunk_by(["one", "two", "three", "four", "five", "six"], &String.length(&1))
[["one", "two"], ["three"], ["four", "five"], ["six"]]

# Enum.map_every
# Algunas veces hacer chunk a una colección no es suficiente para lograr lo que necesitas. Si este es el caso, map_every/3 puede ser muy útil para ejecutarse cada n elementos, siempre se ejecuta en el primero.

# Aplicar la funcion cada 3 items
Enum.map_every([1, 2, 3, 4, 5, 6, 7, 8], 3, fn x -> x + 1000 end)
Enum.map_every([1, 2, 3, 4, 5, 6, 7, 8], 3, &(&1 + 1000))
[1001, 2, 3, 1004, 5, 6, 1007, 8]

# Enum.each
# Iterar sobre una colección sin producir un nuevo valor
Enum.each(["one", "two", "three"], fn s -> IO.puts(s) end)
Enum.each(["one", "two", "three"], &IO.puts/1)
# one
# two
# three
# :ok

# Enum.map
# Para aplicar una función a cada elemento y producir una nueva colección revisa la función map/2:
Enum.map([0, 1, 2, 3], fn x -> x - 1 end)
Enum.map([0, 1, 2, 3], &(&1 - 1))
[-1, 0, 1, 2]

# Enum.min
# Encuentra el valor mínimo de la colección
Enum.min([5, 3, 0 - 1])
-1

# Enum.min/2 realiza lo mismo, pero en caso que el enumerable sea vacío, este permite que se especifique una función que produzca el valor del mínimo.
Enum.min([], fn -> :foo end)
:foo

# Enum.max
# max/1 retorna el máximo valor de la colección:
Enum.max([5, 3, 0, -1])
5
# max/2 es a max/1 lo que min/2 es a min/1:
Enum.max([], fn -> :bar end)
:bar

# Enum.filter
# La función filter/2 nos permite filtrar una colección que incluya solamente aquellos elementos que evalúan a true utilizando la función provista.
Enum.filter([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
Enum.filter([1, 2, 3, 4], &(rem(&1, 2) === 0))
[2, 4]

# Enum.reduce
# Con reduce/3 podemos transformar nuestra colección a un único valor. Para hacer esto aplicamos un acumulador opcional (10 en este ejemplo) que será pasado a nuestra función; si no se provee un acumulador, el primer valor en el enumerable es usado:
Enum.reduce([1, 2, 3], 10, fn x, acc -> x + acc end)
Enum.reduce([1, 2, 3], 10, &(&1 + &2))
16

Enum.reduce([1, 2, 3], fn x, acc -> x + acc end)
Enum.reduce([1, 2, 3], &(&1 + &2))
6

Enum.reduce(["a", "b", "c"], "1", fn x, acc -> x <> acc end)
Enum.reduce(["a", "b", "c"], "1", &(&1 <> &2))
"cba1"

# Enum.sort
# Ordenar nuestras colecciones se hace fácil no con una, sino dos funciones de ordenación. sort/1 utiliza el ordenamiento de términos de Erlang para determinar el orden de ordenación:
Enum.sort([5, 6, 1, 3, -1, 4])
[-1, 1, 3, 4, 5, 6]

Enum.sort([:foo, "bar", Enum, -1, 4])
[-1, 4, Enum, :foo, "bar"]

# Mientras que sort/2 nos permite proveer una función de ordenación propia:

# con nuestra función
Enum.sort([%{:count => 4}, %{:count => 1}], fn x, y -> x[:count] > y[:count] end)
Enum.sort([%{:count => 4}, %{:count => 1}], &(&1[:count] > &2[:count]))
[%{count: 4}, %{count: 1}]

# sin nuestra función
Enum.sort([%{:count => 4}, %{:count => 1}])
[%{count: 1}, %{count: 4}]

# Enum.uniq
# Podemos usar uniq/1 para eliminar duplicados de nuestras colecciones:
Enum.uniq([1, 2, 3, 2, 1, 1, 1, 1, 1])
[1, 2, 3]

# Enum.uniq_by
# También remueve los duplicados pero permite usar una función para hacer la comparación de elemento único
Enum.uniq_by([%{x: 1, y: 1}, %{x: 2, y: 1}, %{x: 3, y: 3}], fn coord -> coord.y end)
Enum.uniq_by([%{x: 1, y: 1}, %{x: 2, y: 1}, %{x: 3, y: 3}], & &1.y)
[%{x: 1, y: 1}, %{x: 3, y: 3}]

# Enum con operador Capture (&)
# Muchas funciones dentro del módulo Enum en Elixir toman funciones anónimas como argumento para trabajar con cada iterable del enumerable que se pasa.

# Estas funciones anónimas a menudo se escriben de forma abreviada utilizando el operador de captura (&).

# A continuación, se muestran algunos ejemplos que muestran cómo se puede implementar el operador de captura con el módulo Enum. Cada versión es funcionalmente equivalente.

# Usando el operador de captura con una función anónima
# A continuación se muestra un ejemplo típico de la sintaxis estándar cuando se pasa una función anónima a Enum.map/2.
Enum.map([1, 2, 3], fn number -> number + 3 end)
[4, 5, 6]

# Ahora implementamos el operador de captura (&); capturar cada iterable de la lista de números ([1,2,3]) y asignar cada iterable a la variable & 1 a medida que se pasa a través de la función de mapeo.
Enum.map([1, 2, 3], &(&1 + 3))
[4, 5, 6]

# Esto se puede refactorizar aún más para asignar la función anónima anterior que presenta el operador Capture a una variable y se puede llamar desde la función Enum.map/2.

plus_three = &(&1 + 3)
Enum.map([1, 2, 3], plus_three)
[4, 5, 6]

# Usando el operador de captura con una función con nombre
# Primero creamos una función nombrada y la llamamos dentro de la función anónima definida en Enum.map/2.
defmodule Adding do
  def plus_three(number), do: number + 3
end

Enum.map([1, 2, 3], fn number -> Adding.plus_three(number) end)
[4, 5, 6]
# A continuación, podemos refactorizar para usar el operador Capturar.
Enum.map([1, 2, 3], &Adding.plus_three(&1))
[4, 5, 6]

# Para obtener la sintaxis más abreviada, podemos llamar directamente a la función nombrada sin capturar explícitamente la variable.
Enum.map([1, 2, 3], &Adding.plus_three/1)
[4, 5, 6]
