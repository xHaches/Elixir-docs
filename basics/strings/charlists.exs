# Charlists

# Internamente, los strings en elixir son representados con una secuencia de bytes en lugar de un array de caracteres. Elixir también tiene un tipo de lista de caraceters(character list). Los strings en elixir se declaran entre comillas dobles, mientras que los char lists entre comillas simples

# ¿Cuál es la diferencia? Cada valor en un charlist es su código en Unicode, mientras que en un binario, los valores están codificados en UTF-8:

# Charlist - Unicode
'hełło'
[104, 101, 322, 322, 111]

# String - UTF-8
"hełło" <> <<0>>
<<104, 101, 197, 130, 197, 130, 111, 0>>

# 322 es el punto de código Unicode para ł pero está codificado en UTF-8 como los dos bytes 197, 130.

# Puedes obtener el code point de un caracter usando (?)
?Z
# 90

# Esto le permite utilizar la notación? Z en lugar de "Z" para un símbolo.

# Cuando programamos en Elixir, usualmente usamos cadenas, no listas de caracteres. El soporte de charlist se incluye principalmente porque es necesario para algunos módulos de Erlang.
