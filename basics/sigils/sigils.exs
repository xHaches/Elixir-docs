# Sigils
# Sintaxis alternativa para trabajar y representar literales
# ~C Genera una lista de caracteres sin escapado o interpolación
# ~c Genera una lista de caracteres con escapado e interpolación
# ~R Genera una expresión regular sin escapado o interpolación
# ~r Genera una expresión regular con escapado e interpolación
# ~S Genera una cadena sin escapado o interpolación
# ~s Genera una cadena con escapado e interpolación
# ~W Genera una lista de palabras sin escapado o interpolación
# ~w Genera una lista de palabras con escapado e interpolación
# ~N Genera una estructura NaiveDateTime

# Una lista de delimitadores incluye:

# <...> Un par de simbolos de mayor/menor
# {...} Un par de llaves
# [...] Un par de corchetes
# (...) Un par de paréntesis
# |...| Un par de pipes
# /.../ Un par de slashes
# "..." Un par de comillas dobles
# '...' Un par de comillas simples

# Lista de caracteres
# Los sigilos ~c y ~C generan lista de caracteres. Por ejemplo:
~c/2 + 7 = #{2 + 7}/
'2 + 7 = 9'
~C/2 + 7 = #{2 + 7}/
'2 + 7 = #{2 + 7}'

# Podemos ver que el sigilo ~c en minúscula interpola el cálculo mientras que el sigilo ~C en mayúscula no. Veremos que esta secuencia mayúscula / minúscula es un tema común en todos los sigilos incorporados.

# Expresiones regulares
# Los sigilos ~r y ~R son usados para representar Expresiones Regulares. Los creamos ya sea sobre la marcha o para usarlos dentro de funciones del módulo Regex. Por ejemplo:
re = ~r/elixir/
"Elixir" =~ re
# false
"elixir" =~ re
true

# Podemos ver que en la primera prueba de igualdad, Elixir no coincide con la expresión regular, esto es porque esta en mayúsculas, porque Elixir soporta Compatible Regular Expressions (PCRE), podemos agregar i al final de nuestro sigilo para apagar la sensibilidad a mayúsculas.

re = ~r/elixir/i
~r/elixir/i

"Elixir" =~ re
true

"elixir" =~ re
true

# Elixir provee la API Regex la cual esta construida sobre la biblioteca de expresiones regulares de Erlang. Vamos a implementar Regex.split/2 usando una sigilo de expresión regular:

string = "100_000_000"
Regex.split(~r/_/, string)
# ["100", "000", "000"]

# Cadena
# Los sigilos ~s y ~S son usados para generar cadenas. Por ejemplo:
~s/the cat in the hat on the mat/
# "the cat in the hat on the mat"
~S/the cat in the hat on the mat/
# "the cat in the hat on the mat"

# ¿Cuál es la diferencia? La diferencia es similar al sigilo de lista de caracteres que ya vimos. La respuesta es interpolación y el uso de secuencias de escape. Si tomamos otro ejemplo:

~s/welcome to elixir #{String.downcase("SCHOOL")}/
# "welcome to elixir school"

~S/welcome to elixir #{String.downcase "SCHOOL"}/
# "welcome to elixir \#{String.downcase \"SCHOOL\"}"

# Lista de palabras
# El sigilo de lista de palabras puede ser útil de vez en cuando. Puede ahorra tiempo, pulsaciones de teclas y sin duda reducir la complejidad dentro del código. Tomemos este sencillo ejemplo:
~w/i love elixir school/
# ["i", "love", "elixir", "school"]

~W/i love elixir school/
# ["i", "love", "elixir", "school"]

# Podemos ver que lo que es escrito entre los delimitadores es separado por espacios en blanco dentro de una lista, no hay diferencia entre estos dos ejemplos. Otra vez la diferencia viene con la interpolación y las secuencia de escape. Tomemos el siguiente ejemplo:
~w/i love #{'e'}lixir school/
["i", "love", "elixir", "school"]

~W/i love #{'e'}lixir school/
["i", "love", "\#{'e'}lixir", "school"]

# NaiveDateTime
# Una NaiveDateTime puede ser útil para crear rápidamente una estructura para representar un Datetime sin zona horaria.

# En la mayor parte, deberiamos evitar crear una estructura NaiveDatetime directamente. Sin embargo, es muy útil para la pattern matching. Por ejemplo:

NaiveDateTime.from_iso8601("2015-01-23 23:50:07") == {:ok, ~N[2015-01-23 23:50:07]}

# Creando Sigilos
# Uno de los objetivos de Elixir es ser un lenguaje de programación extensible. No es una sorpresa entonces que puedas facilmente crear tus propios sigilos. En este ejemplo vamos a crear un sigilo para convertir una cadena a mayúsculas. Como ya hay una función para esto en el núcleo de Elixir (String.upcase/1), envolveremos nuestro sigilo sobre esa función.


$ elixirc mysigils.exs sigils.exs

import MySigils
~u/elixir school/
# ELIXIR SCHOOL
