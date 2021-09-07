# Maps
# En Elixir, los mapas son el tipo de datos utilizado por excelencia para almacenar pares de clave/valor. A diferencia de las listas de palabras clave, los mapas permiten claves de cualquier tipo y no mantienen un orden. Puedes definir un mapa con la sintaxis %{}:

# Se permiten claves de cualquier tipo
map = %{:foo => "bar", "hello" => :world}
map[:foo]
# "bar"
map["hello"]
# :world

# A partir de Elixir 1.2, se pueden usar variables como claves:
key = "hello"
%{key => "world"}
map[key]
# world
map["hello"]
# world

# Si un elemento duplicado es agregado al mapa, este reemplazará el valor anterior:
%{:foo => "bar", :foo => "hello world"}
# %{foo: "hello world"}

# Como podemos ver en la salida anterior, hay una sintaxis especial para los mapas que sólo contienen átomos como claves:

%{foo: "bar", hello: "world"} == %{:foo => "bar", :hello => "world"}
# true

# Adicionalmente, hay una sintaxis especial para acceder a las claves que son átomos:
map = %{foo: "bar", hello: "world"}
map.hello
# "world"

# Otra característica interesante de los mapas es que poseen su propia sintaxis para realizar operaciones de actualización (nota: esto crea un nuevo mapa):

map = %{foo: "bar", hello: "world"}
%{map | foo: "baz"}
# Crea un nuevo mapa
# %{foo: "baz", hello: "world"}

# Nota: ¡esta sintaxis solo puede usarse para actualizar una clave que ya existe en el mapa! Si la clave no existe, se lanzará un KeyError (Error de Clave, en inglés).

# Para crear una nueva clave, en vez utiliza Map.put/3:

map = %{hello: "world"}
%{map | foo: "baz"}
# ** (KeyError) key :foo not found in: %{hello: "world"}
#     (stdlib) :maps.update(:foo, "baz", %{hello: "world"})
#     (stdlib) erl_eval.erl:259: anonymous fn/2 in :erl_eval.expr/5
#     (stdlib) lists.erl:1263: :lists.foldl/3
Map.put(map, :foo, "baz")
%{foo: "baz", hello: "world"}
