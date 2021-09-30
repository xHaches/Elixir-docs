# protocols

# Entonces, ¿qué son? Los protocolos son un medio para lograr polimorfismo en Elixir. Uno de los problemas de Erlang es extender una API existente para tipos recién definidos. Para evitar esto en Elixir, la función se distribuye dinámicamente en función del tipo de valor. Elixir viene con varios protocolos integrados, por ejemplo, el protocolo String.Chars es responsable de la función to_string/1 que hemos visto anteriormente. Echemos un vistazo más de cerca a to_string/1 con un ejemplo rápido:

iex> to_string(5)
"5"
iex> to_string(12.4)
"12.4"
iex> to_string("foo")
"foo"

# Como puede ver, llamamos a la función en varios tipos y demostramos que funciona en todos ellos. ¿Qué pasa si llamamos a to_string / 1 en tuplas (o cualquier tipo que no haya implementado String.Chars)? Vamos a ver:

to_string({:foo})
** (Protocol.UndefinedError) protocol String.Chars not implemented for {:foo}
    (elixir) lib/string/chars.ex:3: String.Chars.impl_for!/1
    (elixir) lib/string/chars.ex:17: String.Chars.to_string/1


# Como puede ver, obtenemos un error de protocolo ya que no hay implementación para tuplas. En la siguiente sección, implementaremos el protocolo String.Chars para tuplas.

# Implementando un protocol
Vimos que to_string / 1 aún no se ha implementado para tuplas, así que agreguemoslo. Para crear una implementación, usaremos defimpl con nuestro protocolo y proporcionaremos la opción: for y nuestro tipo. Echemos un vistazo a cómo podría verse:

defimpl String.Chars, for: Tuple do
  def to_string(tuple) do
    interior =
      tuple
      |> Tuple.to_list()
      |> Enum.map(&Kernel.to_string/1)
      |> Enum.join(", ")

    "{#{interior}}"
  end
end

# Si copiamos esto en IEx, ahora deberíamos poder llamar a to_string/1 en una tupla sin obtener un error:

iex> to_string({3.14, "apple", :pie})
"{3.14, apple, pie}"

# Sabemos cómo implementar un protocolo pero ¿cómo definimos uno nuevo? Para nuestro ejemplo, implementaremos to_atom/1. Veamos cómo hacer eso con defprotocol:

defprotocol AsAtom do
  def to_atom(data)
end

defimpl AsAtom, for: Atom do
  def to_atom(atom), do: atom
end

defimpl AsAtom, for: BitString do
  defdelegate to_atom(string), to: String
end

defimpl AsAtom, for: List do
  defdelegate to_atom(list), to: List
end

defimpl AsAtom, for: Map do
  def to_atom(map), do: List.first(Map.keys(map))
end

# Aquí hemos definido nuestro protocolo y su función esperada, to_atom/1, junto con implementaciones para algunos tipos. Ahora que tenemos nuestro protocolo, pongámoslo en práctica en IEx:

iex> import AsAtom
AsAtom
iex> to_atom("string")
:string
iex> to_atom(:an_atom)
:an_atom
iex> to_atom([1, 2])
:"\x01\x02"
iex> to_atom(%{foo: "bar"})
:foo

# Vale la pena señalar que, aunque debajo de las estructuras están Maps, no comparten implementaciones de protocolo con Maps. No son enumerables, no se puede acceder a ellos.
