# A medida que comienza a trabajar en Elixir, IEx es su mejor amigo. Es un REPL, pero tiene muchas características avanzadas que pueden hacer la vida más fácil al explorar código nuevo o desarrollar su trabajo sobre la marcha. Hay una gran cantidad de ayudantes incorporados que repasaremos en esta lección.

# Autocompletar
# Cuando trabaja en el shell, a menudo puede encontrarse utilizando un nuevo módulo con el que no está familiarizado. Para comprender algo de lo que está disponible para usted, la funcionalidad de autocompletar es maravillosa. Simplemente escriba un nombre de módulo seguido de. luego presione Tab:

iex> Map. # press Tab
delete/2             drop/2               equal?/2
fetch!/2             fetch/2              from_struct/1
get/2                get/3                get_and_update!/3
get_and_update/3     get_lazy/3           has_key?/2
keys/1               merge/2              merge/3
new/0                new/1                new/2
pop/2                pop/3                pop_lazy/3
put/3                put_new/3            put_new_lazy/3
replace!/3           replace/3            split/2
take/2               to_list/1            update!/3
update/4             values/1

# ¡Y ahora conocemos las funciones que tenemos y su aridad!

# .iex.exs
# Cada vez que se inicia IEx, buscará un archivo de configuración .iex.exs. Si no está presente en el directorio actual, el directorio de inicio del usuario (~ / .iex.exs) se utilizará como respaldo.

# Las opciones de configuración y el código definido dentro de este archivo estarán disponibles cuando se inicie el shell IEx. Por ejemplo, si queremos algunas funciones auxiliares disponibles para nosotros en IEx, podemos abrir .iex.exs y hacer algunos cambios.

# Comencemos agregando un módulo con algunas funciones auxiliares:

defmodule IExHelpers do
  def whats_this?(term) when is_nil(term), do: "Type: Nil"
  def whats_this?(term) when is_binary(term), do: "Type: Binary"
  def whats_this?(term) when is_boolean(term), do: "Type: Boolean"
  def whats_this?(term) when is_atom(term), do: "Type: Atom"
  def whats_this?(_term), do: "Type: Unknown"
end


# Ahora, cuando ejecutemos IEx, tendremos el módulo IExHelpers disponible desde el principio. Abra IEx y probemos nuestros nuevos ayudantes:

$ iex
22.0 [10.5.3] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.10.1) - press Ctrl+C to exit (type h() ENTER for help)
iex> IExHelpers.whats_this?("a string")
"Type: Binary"
iex> IExHelpers.whats_this?(%{})
"Type: Unknown"
iex> IExHelpers.whats_this?(:test)
"Type: Atom"

# Como podemos ver, no necesitamos hacer nada especial para requerir o importar nuestros ayudantes, IEx se encarga de eso por nosotros.

# h
# h es una de las herramientas más útiles que nos brinda nuestro shell Elixir. Debido al fantástico soporte de primera clase del lenguaje para la documentación, se puede acceder a los documentos de cualquier código utilizando este ayudante. Verlo en acción es simple:

iex> h Enum
                                      Enum

Provides a set of algorithms that enumerate over enumerables according to the
Enumerable protocol.

┃ iex> Enum.map([1, 2, 3], fn(x) -> x * 2 end)
┃ [2, 4, 6]

Some particular types, like maps, yield a specific format on enumeration.
For example, the argument is always a {key, value} tuple for maps:

┃ iex> map = %{a: 1, b: 2}
┃ iex> Enum.map(map, fn {k, v} -> {k, v * 2} end)
┃ [a: 2, b: 4]

Note that the functions in the Enum module are eager: they always start the
enumeration of the given enumerable.
The Stream module allows lazy enumeration
of enumerables and provides infinite streams.

Since the majority of the functions in Enum enumerate the whole enumerable and
return a list as a result, infinite streams need to be carefully used with such
functions, as they can potentially run forever.
For example:

┃ Enum.each Stream.cycle([1, 2, 3]), &IO.puts(&1)

# Y ahora incluso podemos combinar esto con las funciones de autocompletar de nuestro shell. Imagina que estamos explorando Map por primera vez:

iex> h Map
                                      Map

A set of functions for working with maps.

Maps are key-value stores where keys can be any value and are compared using
the match operator (===).
Maps can be created with the %{} special form defined
in the Kernel.SpecialForms module.

iex> Map.
delete/2             drop/2               equal?/2
fetch!/2             fetch/2              from_struct/1
get/2                get/3                get_and_update!/3
get_and_update/3     get_lazy/3           has_key?/2
keys/1               merge/2              merge/3
new/0                new/1                new/2
pop/2                pop/3                pop_lazy/3
put/3                put_new/3            put_new_lazy/3
split/2              take/2               to_list/1
update!/3            update/4             values/1

iex> h Map.merge/2
                             def merge(map1, map2)

Merges two maps into one.

All keys in map2 will be added to map1, overriding any existing one.

If you have a struct and you would like to merge a set of keys into the struct,
do not use this function, as it would merge all keys on the right side into the
struct, even if the key is not part of the struct.
Instead, use
Kernel.struct/2.

Examples

┃ iex> Map.merge(%{a: 1, b: 2}, %{a: 3, d: 4})
┃ %{a: 3, b: 2, d: 4}


# Como podemos ver, no solo pudimos encontrar qué funciones estaban disponibles como parte del módulo, sino que también pudimos acceder a documentos de funciones individuales, muchos de los cuales incluyen ejemplos de uso.


# i
# Usemos algunos de nuestros conocimientos recién descubiertos empleando h para aprender un poco más sobre el ayudante i:

h i

                                  def i(term)

Prints information about the given data type.

iex> i Map
Term
  Map
Data type
  Atom
Module bytecode
  /usr/local/Cellar/elixir/1.3.3/bin/../lib/elixir/ebin/Elixir.Map.beam
Source
  /private/tmp/elixir-20160918-33925-1ki46ng/elixir-1.3.3/lib/elixir/lib/map.ex
Version
  [9651177287794427227743899018880159024]
Compile time
  no value found
Compile options
  [:debug_info]
Description
  Use h(Map) to access its documentation.
  Call Map.module_info() to access metadata.
Raw representation
  :"Elixir.Map"
Reference modules
  Module, Atom

# Ahora tenemos un montón de información sobre Map, incluido dónde se almacena su fuente y los módulos a los que hace referencia. Esto es muy útil al explorar tipos de datos externos personalizados y nuevas funciones.

# Los encabezados individuales pueden ser densos, pero en un nivel alto podemos recopilar información relevante:

# - Es un tipo de datos de átomo
# - Dónde está el código fuente
# - La versión y las opciones de compilación.
# - Una descripción general
# - Como acceder
# - ¿Qué otros módulos hace referencia?
# - Esto nos da mucho con qué trabajar y es mejor que ir a ciegas.

# r
# Si queremos recompilar un módulo en particular, podemos usar el ayudante r. Supongamos que cambiamos algún código y queremos ejecutar una nueva función que agregamos. Para hacer eso, necesitamos guardar nuestros cambios y recompilar con r:

r MyProject
warning: redefining module MyProject (current version loaded from _build/dev/lib/my_project/ebin/Elixir.MyProject.beam)
  lib/my_project.ex:1

{:reloaded, MyProject, [MyProject]}

# t
# El asistente t nos informa sobre los tipos disponibles en un módulo determinado:

iex> t Map
@type key() :: any()
@type value() :: any()

# Y ahora sabemos que Map define tipos de clave y valor en su implementación. Si vamos y miramos el codigo de Map:

defmodule Map do
  # ...
    @type key :: any
    @type value :: any
  # ...

# Este es un ejemplo simple, que indica que las claves y los valores por implementación pueden ser de cualquier tipo, pero es útil saberlo.

# Al aprovechar todas estas sutilezas integradas, podemos explorar fácilmente el código y aprender más sobre cómo funcionan las cosas. IEx es una herramienta muy poderosa y robusta que empodera a los desarrolladores. ¡Con estas herramientas en nuestra caja de herramientas, explorar y construir puede ser aún más divertido!
