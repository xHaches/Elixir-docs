# Convenciones generales
# Por el momento, la comunidad de Elixir ha llegado a algunas convenciones con respecto a la devolución de errores:

# Para los errores que son parte del funcionamiento normal de una función (por ejemplo, un usuario ingresó un tipo de fecha incorrecto), una función devuelve     {:ok, result} y {:error, reason} en consecuencia.
# Para los errores que no forman parte de las operaciones normales (por ejemplo, no poder analizar los datos de configuración), lanza una excepción.
# Por lo general, manejamos los errores de flujo estándar mediante la coincidencia de patrones, pero en esta lección nos centraremos en el segundo caso: las excepciones.

# A menudo, en las API públicas, también puede encontrar una segunda versión de la función con un !(example!/1) que devuelve el resultado sin empaquetar o genera un error.

# Manejo de errores

# Antes de manejarlo necesitamos crearlos, la forma más fácil es con raise/1:
iex> raise "Oh no!"
** (RuntimeError) Oh no!

# Si queremos especificar el tipo y el mensaje, necesitamos usar raise/2:

iex> raise ArgumentError, message: "the argument value is invalid"
** (ArgumentError) the argument value is invalid

# Cuando sabemos que un error podría ocurrir, lo manejamos usando try/rescue y pattern matching:

iex> try do
  ...>   raise "Oh no!"
  ...> rescue
  ...>   e in RuntimeError -> IO.puts("An error occurred: " <> e.message)
  ...> end
An error occurred: Oh no!
:ok

# Es posible enlacar multiples errores en un solo rescue:
try do
  ops
  |> Keyword.fetch!(:source_file)
  |> File.read!()
rescue
  e in KeyError -> IO.puts("Missing :source_file option")
  e in File.Error -> IO.puts("unable to read source file")
end
