# Funciones y pattern matching
# Detrás de escenas, las funciones se ajustan a el numero de argumentos con los que se llaman.

# Digamos que necesitamos una función para aceptar un mapa, pero solo nos interesa utilizar una llave en particular. Podemos coincidir el argumento con la llave de la siguiente forma:

defmodule Greeter1 do
  def hello(%{name: person_name}) do
    IO.puts("Hello, " <> person_name)
  end
end

# Digamos que tenemos el siguiente mapa:
fred = %{
  name: "Fred",
  age: "95",
  favorite_color: "Taupe"
}

# Estos son los resultados que obtenemos al llamar Greeter1.hello/1 con el mapa fred:
Greeter1.hello(fred)
# "Hello, Fred"

# ¿Qué sucede cuando llamamos la función con un mapa que no contiene la llave :name?

# call without the key we need returns an error
Greeter1.hello(%{age: "95", favorite_color: "Taupe"})
# ** (FunctionClauseError) no function clause matching in Greeter1.hello/1

# La razón de este comportamiento es que Elixir busca la coincidencia de los argumentos con los que se llama la función con la aridad con la que se define la función.
# Pensemos en como se ven los datos cuando llegan a Greeter1.hello/1:

# incoming map
# fred = %{
# name: "Fred",
# age: "95",
# favorite_color: "Taupe"
# }

# Greeter1.hello/1 espera un argumento como el siguiente:
%{name: person_name}

# En Greeter1.hello/1, el mapa que pasamos (fred) se evalúa comparandolo con nuestro argumento (%{name: person_name}):

%{name: person_name} = %{name: "Fred", age: "95", favorite_color: "Taupe"}

# Encuentra que existe una llave que corresponde a :name en el mapa proporcionado. ¡Tenemos una coincidencia! y como resultado de esta coincidencia exitosa, el valor de la llave :name en el mapa de la derecha (Por ejemplo el mapa fred) esta vinculado a la variable de la izquierda (person_name).

# Ahora, ¿qué sucede si quisiéramos asignar el nombre de Fred a person_name pero TAMBIÉN queremos acceder a todo el mapa? Digamos que queremos hacer IO.inspect(fred) despues de saludarlo. En este punto, debido a que solo buscamos la llave :name en nuestro mapa, solo vinculamos el valor de esa llave a una variable, la función no tiene conocimiento del resto del mapa.

# Para poder conservarlo, debemos asignar ese mapa completo a su propia variable para que podamos utilizarlo.

# Empecemos una nueva función:
defmodule Greeter2 do
  # Pattern matching con todo el map fred
  def hello(%{name: person_name} = person) do
    IO.puts("Hello, " <> person_name)
    IO.inspect(person)
  end
end

# Recuerde que Elixir buscara la coincidencia a medida de que se presente. Por lo tanto, en este caso, cada lado buscara la coincidencia con el argumento entrante y se unirá a lo que corresponda. Tomemos el lado derecho primero:
person = %{name: "Fred", age: "95", favorite_color: "Taupe"}

# Ahora, person a sido evaluado y vinculado a todo el mapa de fred. Pasemos a la siguiente coincidencia:

%{name: person_name} = %{name: "Fred", age: "95", favorite_color: "Taupe"}

# Ahora esto es lo mismo a nuestra función original Greeter1 en la que la que solo buscábamos la coincidencia con el mapa y solo reteníamos el nombre de Fred. Lo que hemos logrado son dos variable que podemos usar en lugar de una:

# 1. person, refiriéndose a %{name: "Fred", age: "95", favorite_color: "Taupe"}
# 2. person_name, refiriéndose a "Fred"

# Así que ahora cuando llamamos Greeter2.hello/1, podemos usar toda la información de Fred:

# call with entire person
Greeter2.hello(fred)
"Hello, Fred"
%{age: "95", favorite_color: "Taupe", name: "Fred"}
# call with only the name key
Greeter2.hello(%{name: "Fred"})
"Hello, Fred"
%{name: "Fred"}
# call without the name key
Greeter2.hello(%{age: "95", favorite_color: "Taupe"})
# ** (FunctionClauseError) no function clause matching in Greeter2.hello/1

# Así que hemos visto que las coincidencias en Elixir se ajustan a múltiples profundidades porque cada argumento se compara con los datos entrantes de forma independiente, dejandonos las variables para llamarlas dentro de nuestra función.

# Si cambiamos el orden de %{name: person_name} y person en la lista, obtendremos los mismos resultados ya que cada uno coincide con fred por su cuenta.

# Cambiamos la variable y el mapa:
defmodule Greeter3 do
  def hello(person = %{name: person_name}) do
    IO.puts("Hello, " <> person_name)
    IO.inspect(person)
  end
end

# Y llamémoslo con los mismos datos que usamos en Greeter2.hello/1:
# call with same old Fred
Greeter3.hello(fred)
"Hello, Fred"
%{age: "95", favorite_color: "Taupe", name: "Fred"}

# Continuar escribiendo Recordemos que aunque parezca que %{name: person_name} = person hace coincidir los patrones con %{name: person_name} contra la variable person, en realidad esta haciendo coincidir los patrones con los argumentos proporcionados.

# Resumen: Las funciones buscan coincidencia con cada uno de los datos proporcionados de forma independiente. Podemos usar esto para vincular valores a variables separadas dentro de la función.
