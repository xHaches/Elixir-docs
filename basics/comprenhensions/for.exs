# basics
# Las comprensiones a menudo se pueden usar para producir declaraciones más concisas para la iteración Enum y Stream. Comencemos por mirar una comprensión simple y luego desglosarla:

list = [1, 2, 3, 4, 5]
for x <- list, do: x * x
[1, 4, 9, 16, 25]

# Lo primero que notamos es el uso de for y un generador. ¿Qué es un generador? Los generadores son las expresiones x <- [1, 2, 3, 4] que se encuentran en las listas por comprensión. Son responsables de generar el próximo valor.

# Por suerte para nosotros, las comprensiones no se limitan a las listas; de hecho, trabajarán con cualquier enumerable:

# Keyword Lists
for {_key, val} <- [one: 1, two: 2, three: 3], do: val
[1, 2, 3]

# Maps
for {k, v} <- %{"a" => "A", "b" => "B"}, do: {k, v}
[{"a", "A"}, {"b", "B"}]

# Binaries
for <<c <- "hello">>, do: <<c>>
["h", "e", "l", "l", "o"]

# Como muchas otras cosas en Elixir, los generadores se basan en la coincidencia de patrones para comparar su conjunto de entrada con la variable del lado izquierdo. En caso de que no se encuentre una coincidencia, el valor se ignora:

for {:ok, val} <- [ok: "Hello", error: "Unknown", ok: "World"], do: val
["Hello", "World"]

# Es posible utilizar varios generadores, al igual que los bucles anidados:

list = [1, 2, 3, 4]

for n <- list, times <- 1..n do
  String.duplicate("*", times)
end

["*", "*", "**", "*", "**", "***", "*", "**", "***", "****"]

# Para ilustrar mejor el bucle que se está produciendo, usemos IO.puts para mostrar los dos valores generados:

for n <- list, times <- 1..n, do: IO.puts("#{n} - #{times}")
1 - 1
2 - 1
2 - 2
3 - 1
3 - 2
3 - 3
4 - 1
4 - 2
4 - 3
4 - 4

# Las listas por comprensión son azúcar sintáctico y deben usarse solo cuando sea apropiado.

# Puede pensar en los filtros como una especie de guardia para las comprensiones. Cuando un valor filtrado devuelve falso o nulo, se excluye de la lista final. Vamos a recorrer un rango y solo nos preocupan los números pares. Usaremos la función is_even / 1 del módulo Integer para verificar si un valor es par o no.

import Integer
for x <- 1..10, is_even(x), do: x
[2, 4, 6, 8, 10]

# Al igual que los generadores, podemos utilizar varios filtros. Ampliemos nuestro rango y luego filtremos solo los valores que sean par y uniformemente divisibles por 3.

import Integer
for x <- 1..100, is_even(x), rem(x, 3) == 0, do: x
[6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 96]

# :into

# ¿Qué pasa si queremos producir algo más que una lista? Dada la opción: into, ¡podemos hacer precisamente eso! Como regla general,: into acepta cualquier estructura que implemente el protocolo Collectable.

# Usando: into, creemos un mapa a partir de una lista de palabras clave:

for {k, v} <- [one: 1, two: 2, three: 3], into: %{}, do: {k, v}
%{one: 1, three: 3, two: 2}

# Dado que los binarios son coleccionables, podemos usar comprensión de listas e :into para crear strings:

for c <- [72, 101, 108, 108, 111], into: "", do: <<c>>
"Hello"

# ¡Eso es todo! Las listas por comprensión son una forma fácil de recorrer las colecciones de forma concisa.
