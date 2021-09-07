[3.14, :pie, "Apple"]

# Elixir implementa las colecciones como listas enlazadas. Esto significa que acceder al largo de la lista es una operación que se ejecutará en tiempo lineal (O(n)). Por esta razón, normalmente es más rápido agregar un elemento al inicio que al final:

# las listas No son contiguas

list = [3.14, :pie, "Apple"]
# Agregar elemento al inicio de la lista (rápido)
["π" | list]
# ["π", 3.14, :pie, "Apple"]
# Agregar elemento al final de la lista (lento)
# list ++ ["Cherry"]
# [3.14, :pie, "Apple", "Cherry"]

# Concatenar listas
# [1, 2] ++ [3, 4, 1]
# [1, 2, 3, 4, 1]
# [1, 2 | [3, 4, 1]]
# [1, 2, 3, 4, 1]

# Sustracción de listas
# ["foo", :bar, 42] -- [42, "bar"]
# ["foo", :bar]

# Tenga en cuenta los valores duplicados. Para cada elemento de la lista derecha, la primera ocurrencia se retira de la lista izquierda.
# [1,2,2,3,2,3] -- [1,2,3,2]
# [2, 3]

# El operador -- usa la comparacion estricta
# [2] -- [2.0]
# [2]
# [2.0] -- [2.0]
# []

# head/tail
# hd([3.14, :pie, "Apple"])
# 3.14

# tl([3.14, :pie, "Apple", "Hello", "world"])
# [:pie, "Apple", "Hello", "world"]

# partir una lista en cabeza-cola
[head | tail] = [3.14, :pie, "Apple"]
[3.14, :pie, "Apple"]
head
# 3.14
tail
# [:pie, "Apple"]
