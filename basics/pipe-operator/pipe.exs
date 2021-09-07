# Pipe
# El operador pipe |> pasa el resultado de una expresión como primer parámetro de otra expresión.

# La programación puede complicarse. De hecho, es tan complicado que las llamadas a funciones pueden incrustarse tanto que se vuelven difíciles de seguir. Tenga en cuenta las siguientes funciones anidadas:

# foo(bar(baz(new_function(other_function()))))

# Aquí, estamos pasando el valor other_function / 0 a new_function / 1, y new_function / 1 a baz / 1, baz / 1 a bar / 1, y finalmente el resultado de bar / 1 a foo / 1. Elixir adopta un enfoque pragmático de este caos sintáctico al darnos el operador de tubería. El operador de tubería |> toma el resultado de una expresión y lo transmite. Echemos otro vistazo al fragmento de código anterior reescrito con el operador de tubería.

# other_function() |> new_function() |> baz() |> bar() |> foo()

# Ejemplos
"Elixir rocks" |> String.split()
["Elixir", "rocks"]

"Elixir rocks" |> String.upcase() |> String.split()
["ELIXIR", "ROCKS"]

"elixir" |> String.ends_with?("ixir")
true

# Si la aridad de una función es mayor que 1, asegúrese de usar paréntesis. Esto no le importa mucho a Elixir, pero sí a otros programadores que pueden malinterpretar su código. Sin embargo, sí importa con el operador de la tubería. Por ejemplo, si tomamos nuestro tercer ejemplo y eliminamos los paréntesis de String.ends_with? / 2, nos encontramos con la siguiente advertencia.

# "elixir" |> String.ends_with? "ixir"
# warning: parentheses are required when piping into a function call.
# For example:

#   foo 1 |> bar 2 |> baz 3

# is ambiguous and should be written as

#   foo(1) |> bar(2) |> baz(3)

true
