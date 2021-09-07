# cond
# Cuando necesitamos coincidencias con condiciones, y no valores, podemos cambiar a cond; esto es parecido a else if o elsif en otros lenguajes:
cond do
  2 + 2 === 5 -> "This will not be true"
  2 * 2 === 3 -> "Nor this"
  1 + 1 === 2 -> "But this will"
end

"But this will"

# Como case, cond lanzará un error si no hay una coincidencia. Para manejar esto, podemos definir una condición cuyo valor es true:
cond do
  7 + 1 === 0 -> "Incorrect"
  true -> "Catch all"
end

# "Catch all"
