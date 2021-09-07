# Match operator (=)
# ¿Estás listo para algo un poco sorprendente? En Elixir, el operador = es en realidad un operador de coincidencia, comparable al signo igual en el álgebra. Escribirlo transforma la expresión en una igualdad y hace que Elixir haga coincidencia de los valores del lado izquierdo con los del derecho. Si la coincidencia es exitosa, esta retorna el valor de la ecuación. De lo contrario, esta lanzará un error. Echemos un vistazo:
x = 1
1

# Con una coincidencia simple
1 = x
2 = x
# ** (MatchError) no match of right hand side value: 1

# Vamos a intentar esto con algunas de las colecciones que conocemos:
# Listas
list = [1, 2, 3]
[1, 2, 3]
[1, 2, 3] = list
[1, 2, 3]
[] = list
# ** (MatchError) no match of right hand side value: [1, 2, 3]
[1 | tail] = list
[1, 2, 3]
tail
# => [2, 3]
[2 | _] = list
# ** (MatchError) no match of right hand side value: [1, 2, 3]

# Tuplas
{:ok, value} = {:ok, "Successful!"}
{:ok, "Successful!"}
value
# => "Successful!"
{:ok, value} = {:error}
# ** (MatchError) no match of right hand side value: {:error}

# Pin operator (^)
# El operador (=) Realiza una asignación cuando el lado izquierdo es o incluye una variable. En algunos casos reenlazar la variable no es el comportamiento deseado. Para esas situaciones, tenemos el operador ^ (pin).

# Cuando usamos el operador pin con una variable, hacemos una coincidencia sobre el valor existente en lugar de enlazarlo a uno nuevo. Vamos a ver cómo funciona esto:

x = 1
^x = 2
# ** (MatchError) no match of right hand side value: 2
{x, ^x} = {2, 1}
{2, 1}
x
# => 2

# Elixir 1.2 introduce soporte para usar el operador pin en las claves de los mapas y en las cláusulas de función:
key = "hello"
"hello"

%{^key => value} = %{"hello" => "world"}
%{"hello" => "world"}
value
"world"
%{^key => value} = %{:hello => "world"}
# ** (MatchError) no match of right hand side value: %{hello: "world"}

# Un ejemplo de usar el operador pin en una cláusula de función:
greeting = "Hello"
"Hello"

greet = fn
  ^greeting, name -> "Hi #{name}"
  greeting, name -> "#{greeting}, #{name}"
end

greet.("Hello", "Sean")
"Hi Sean"
greet.("Mornin'", "Sean")
"Mornin', Sean"

# Nota que en el ejemplo "Mornin" que la reasignación de greeting a "Mornin" solo ocurre dentro de la función. Afuera de la función greeting aún es "Hello".
