# Keyword lists
# Las listas de palabras clave y los mapas son las colecciones asociativas de Elixir. En Elixir, una lista de palabras clave es una lista especial de tuplas de dos elementos, cuyos primeros elementos son átomos; éstas tienen el mismo rendimiento que las listas:

# Ejemplo para lista
[foo: "bar", hello: "world"]

# Ejemplo para tupla
[{:foo, "bar"}, {:hello, "world"}]

# Las tres características de las listas de palabras clave que resaltan su importancia son:

# Las claves son átomos.
# Las claves están ordenadas.
# Las claves pueden no ser únicas.

# Es por esto que las listas de palabras clave son comúnmente usadas para pasar opciones a funciones.
