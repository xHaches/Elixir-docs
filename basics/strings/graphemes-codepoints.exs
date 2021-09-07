# Graphemes y CodePoints

# Los codepoints son simples caracteres Unicode que están representados por uno o más bytes, dependiendo de la codificación UTF-8. Los caracteres fuera del conjunto de caracteres ASCII de EE. UU. Siempre se codificarán como más de un byte. Por ejemplo, los caracteres latinos con tilde o acentos (á, ñ, è) generalmente se codifican como dos bytes. Los caracteres de idiomas asiáticos a menudo se codifican como tres o cuatro bytes.

# Los graphenes constan de varios codepoints que se representan como un solo carácter.

# El módulo String ya proporciona dos funciones para obtenerlos, graphemes/1 y codepoints/1. Veamos un ejemplo:

string = "\u0061\u0301"
"á"

String.codepoints(string)
["a", "́"]

String.graphemes(string)
["á"]

# Funciones para strings

# Repasemos algunas de las funciones más importantes y útiles del módulo String. Esta lección solo cubrirá un subconjunto de las funciones disponibles. Para ver un conjunto completo de funciones, visite los documentos oficiales de String.

# length/1
# Devuelve el número de graphemes en la cadena.

String.length("Hello")
5

# replace/3
# Devuelve una nueva cadena que reemplaza un patrón actual en la cadena con una nueva cadena de reemplazo.

String.replace("Hello", "e", "a")
# "Hallo"

# duplicate/2
# Devuelve un string repetido n veces
String.duplicate("Oh my", 3)
"Oh my Oh my Oh my"

# split
# Devuelve una lista de strings separados por un patrón
String.split("Hello World", " ")
["Hello", "World"]

# Ejercicio
# ¡Repasemos un ejercicio simple para demostrar que estamos listos para usar Strings!

# Anagramas
# A y B se consideran anagramas si hay una manera de reorganizar A o B haciéndolos iguales. Por ejemplo:

# A = super
# B = perus
# Si reorganizamos los caracteres en la cadena A, podemos obtener la cadena B y viceversa.

# Entonces, ¿cómo podríamos verificar si dos cadenas son Anagramas en Elixir? La solución más fácil es ordenar los grafemas de cada cadena alfabéticamente y luego verificar si ambas listas son iguales. Intentemos eso:

defmodule Anagram do
  def anagrams?(a, b) when is_binary(a) and is_binary(b) do
    sort_string(a) == sort_string(b)
  end

  def sort_string(string) do
    string
    |> String.downcase()
    |> String.graphemes()
    |> Enum.sort()
  end
end

# Veamos primero los anagrams/2. Estamos comprobando si los parámetros que estamos recibiendo son binarios o no. Esa es la forma en que verificamos si un parámetro es una cadena en Elixir.

# Después de eso, llamamos a una función que ordena la cadena alfabéticamente. Primero convierte la cadena a minúsculas y luego usa String.graphemes/1 para obtener una lista de los grafemas en la cadena. Finalmente, canaliza esa lista a Enum.sort/1. Bastante sencillo, ¿verdad?

# Revisemos la salida:

Anagram.anagrams?("Hello", "ohell")
true

Anagram.anagrams?("María", "íMara")
true

# Anagram.anagrams?(3, 5)
# ** (FunctionClauseError) no function clause matching in Anagram.anagrams?/2

#     The following arguments were given to Anagram.anagrams?/2:

#         # 1
#         3

#         # 2
#         5

#     iex:11: Anagram.anagrams?/2

# Como puede ver, ¿la última llamada a los anagramas? provocó un FunctionClauseError. Este error nos dice que no hay ninguna función en nuestro módulo que cumpla con el patrón de recibir dos argumentos no binarios, y eso es exactamente lo que queremos, solo recibir dos cadenas y nada más.
