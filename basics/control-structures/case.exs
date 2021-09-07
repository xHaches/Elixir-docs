# case
# Si es necesario buscar una coincidencia en múltiples patrones podemos usar case:

case {:ok, "Hello world"} do
  {:ok, result} -> result
  {:error} -> "Uh oh!"
  _ -> "Catch all"
end

# "Hello world

# La variable _ es una inclusión importante en la declaración case. Sin esto, cuando no se encuentre una coincidencia, se lanzará un error:

case :even do
  :odd -> "Odd"
end

# ** (CaseClauseError) no case clause matching: :even

case :even do
  :odd -> "Odd"
  _ -> "Not Odd"
end

# "Not Odd"

# Considera _ como el else que coincidirá con “todo lo demás”. Ya que case se basa en la coincidencia de patrones, se aplican las mismas reglas y restricciones. Si intentas coincidir con variables existentes debes usar el operador pin ^:

pie = 3.14

case "cherry pie" do
  ^pie -> "Not so tasty"
  pie -> "I bet #{pie} is tasty"
end

"I bet cherry pie is tasty"

# Otra característica interesante de case es que soporta cláusulas de guardia:

case {1, 2, 3} do
  {1, x, 3} when x > 0 -> "Will match"
  _ -> "Won't match"
end

# "Will match"
