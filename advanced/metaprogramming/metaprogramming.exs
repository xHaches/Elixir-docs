# Metaprogramación
# La metaprogramación es el proceso de usar código para escribir código. En Elixir, esto nos da la capacidad de extender el lenguaje para que se ajuste a nuestras necesidades y cambiar el código de forma dinámica. Comenzaremos por ver cómo se representa Elixir bajo el capó, luego cómo modificarlo y, finalmente, podemos usar este conocimiento para ampliarlo.

# Una advertencia: la metaprogramación es complicada y solo debe usarse cuando sea necesario. Es casi seguro que el uso excesivo conducirá a un código complejo que es difícil de entender y depurar.

# Cita (Quote)
# El primer paso para la metaprogramación es comprender cómo se representan las expresiones. En Elixir, el árbol de sintaxis abstracta (AST), la representación interna de nuestro código, se compone de tuplas. Estas tuplas contienen tres partes: nombre de la función, metadatos y argumentos de la función.

# Para ver estas estructuras internas, Elixir nos proporciona la función quote/2. Usando quote/2 podemos convertir el código de Elixir en su representación subyacente:

iex > quote do: 42
42
iex > quote do: "Hello"
"Hello"
iex > quote do: :world
:world
iex > quote do: 1 + 2
# Nombre de funcion - metadatos - argumentos
{:+, [context: Elixir, import: Kernel], [1, 2]}
iex > quote do: if(value, do: "True", else: "False")
{:if, [context: Elixir, import: Kernel], [{:value, [], Elixir}, [do: "True", else: "False"]]}

# ¿Observaste que los tres primeros no devuelven tuplas? Hay cinco literales que se devuelven a sí mismos cuando se citan(quoted):

iex > :atom
:atom
iex > "string"
"string"
# All numbers
iex > 1
1
# Lists
iex > [1, 2]
[1, 2]
# 2 element tuples
iex > {"hello", :world}
{"hello", :world}

# Unquote
# Ahora que podemos recuperar la estructura interna de nuestro código, ¿cómo lo modificamos? Para inyectar código o valores nuevos usamos unquote/1. usando unquote/1 en una expresión, se evaluará y se inyectará en el AST. Para demostrar unquote/1, veamos algunos ejemplos:

iex > denominator = 2
2
iex > quote do: divide(42, denominator)
# Nombre de funcion - metadatos - argumentos
{:divide, [], [42, {:denominator, [], Elixir}]}
iex > quote do: divide(42, unquote(denominator))
# Nombre de funcion - metadatos - argumentos evaluados dentro de unquote
{:divide, [], [42, 2]}

# Macros
# Una vez que entendamos quote/2 y unquote/1, estaremos listos para sumergirnos en las macros. Es importante recordar que las macros, como toda la metaprogramación, deben usarse con moderación.

# En el más simple de los términos, las macros son funciones especiales diseñadas para devolver una expresión entre comillas que se insertará en el código de nuestra aplicación. Imagine que la macro se reemplaza con la expresión entre comillas en lugar de llamarla como una función. Con las macros tenemos todo lo necesario para extender Elixir y agregar código dinámicamente a nuestras aplicaciones.

# Comenzamos definiendo una macro usando defmacro/2 que, como gran parte de Elixir, es en sí misma una macro (deja que eso se hunda). Como ejemplo, lo implementaremos a menos que sea como una macro. Recuerde que nuestra macro debe devolver una expresión entre comillas:

defmodule OurMacro do
  defmacro unless(expr, do: block) do
    quote do
      if !unquote(expr), do: unquote(block)
    end
  end
end

iex > require OurMacro
nil
iex > OurMacro.unless(true, do: "Hi")
nil
iex > OurMacro.unless(false, do: "Hi")
"Hi"

# Debido a que las macros reemplazan el código en nuestra aplicación, podemos controlar cuándo y qué se compila. Un ejemplo de esto se puede encontrar en el módulo Logger. Cuando el registro está deshabilitado, no se inyecta código y la aplicación resultante no contiene referencias ni llamadas de función al registro. Esto es diferente de otros lenguajes donde todavía existe la sobrecarga de una llamada de función incluso cuando la implementación es NOP.

# Para demostrar esto, crearemos un registrador simple que se puede habilitar o deshabilitar:

defmodule Logger do
  defmacro log(msg) do
    if Application.get_env(:logger, :enabled) do
      quote do
        IO.puts("Logged message: #{unquote(msg)}")
      end
    end
  end
end

defmodule Example do
  require Logger

  def test do
    Logger.log("This is a log message")
  end
end

# With logging enabled our test function would result in code looking something like this:

def test do
  IO.puts("Logged message: #{"This is a log message"}")
end

# If we disable logging the resulting code would be:

def test do
end

# Debugging

# Bien, ahora sabemos cómo usar quote/2, unquote/1 y escribir macros. Pero, ¿qué sucede si tiene una gran cantidad de código entre comillas y desea comprenderlo? En este caso, puede utilizar Macro.to_string/2. Echale un vistazo a éste ejemplo:

iex > Macro.to_string(quote(do: foo.bar(1, 2, 3)))
"foo.bar(1, 2, 3)"

# Y cuando desee ver el código generado por macros, puede combinarlos con Macro.expand /2 y Macro.expand_once/2, estas funciones expanden macros en su código entre comillas. El primero puede expandirlo varias veces, mientras que el segundo, solo una vez. Por ejemplo, modifiquemos a menos que el ejemplo de la sección anterior:

defmodule OurMacro do
  defmacro unless(expr, do: block) do
    quote do
      if !unquote(expr), do: unquote(block)
    end
  end
end

require OurMacro

quoted =
  quote do
    OurMacro.unless(true, do: "Hi")
  end

iex > quoted |> Macro.expand_once(__ENV__) |> Macro.to_string() |> IO.puts()

if(!true) do
  "Hi"
end

# Si ejecutamos el mismo código con Macro.expand / 2, es intrigante:

iex > quoted |> Macro.expand(__ENV__) |> Macro.to_string() |> IO.puts()

case(!true) do
  x when x in [false, nil] ->
    nil

  _ ->
    "Hi"
end

# Puede recordar que mencionamos si es una macro en Elixir, aquí la vemos expandida en la declaración de caso subyacente.

# Macros privadas
# Aunque no es tan común, Elixir admite macros privadas. Una macro privada se define con defmacrop y solo se puede llamar desde el módulo en el que se definió. Las macros privadas deben definirse antes que el código que las invoca.

# Higiene en macros
# La forma en que las macros interactúan con el contexto de la persona que llama cuando se expanden se conoce como higiene de macros. Por defecto, las macros en Elixir son higiénicas y no entrarán en conflicto con nuestro contexto:

defmodule Example do
  defmacro hygienic do
    quote do: val = -1
  end
end

iex > require Example
nil
iex > val = 42
42
iex > Example.hygienic()
-1
iex > val
42

# ¿Y si quisiéramos manipular el valor de val? Para marcar una variable como antihigiénica, podemos usar var!/2. Actualicemos nuestro ejemplo para incluir otra macro que utilice var!/2:

defmodule Example do
  defmacro hygienic do
    quote do: val = -1
  end

  defmacro unhygienic do
    quote do: var!(val) = -1
  end
end

# Comparemos cómo interactúan con nuestro contexto:

iex > require Example
nil
iex > val = 42
42
iex > Example.hygienic()
-1
iex > val
42
iex > Example.unhygienic()
-1
iex > val
-1

# Al incluir var!/2 en nuestra macro, manipulamos el valor de val sin pasarlo a nuestra macro. El uso de macros no higiénicas debe reducirse al mínimo. Al incluir var!/2 aumentamos el riesgo de un conflicto de resolución variable.

# Binding
# Ya cubrimos la utilidad de unquote/1, pero hay otra forma de inyectar valores en nuestro código: vinculante. Con la vinculación de variables podemos incluir múltiples variables en nuestra macro y asegurarnos de que solo estén sin comillas una vez, evitando revalorizaciones accidentales. Para usar variables vinculadas, necesitamos pasar una lista de palabras clave a la opción bind_quoted en quote / 2.

# Para ver el beneficio de bind_quoted y demostrar el problema de la revalorización, usemos un ejemplo. Podemos comenzar creando una macro que simplemente genera la expresión dos veces:

defmodule Example do
  defmacro double_puts(expr) do
    quote do
      IO.puts(unquote(expr))
      IO.puts(unquote(expr))
    end
  end
end

# Probaremos nuestra nueva macro pasándole la hora actual del sistema. Deberíamos esperar verlo dos veces:

iex > Example.double_puts(:os.system_time())
1_450_475_941_851_668_000
1_450_475_941_851_733_000

# ¡Los tiempos son diferentes! ¿Qué sucedió? El uso de unquote/1 en la misma expresión varias veces da como resultado una revalorización y eso puede tener consecuencias no deseadas. Actualicemos el ejemplo para usar bind_quoted y veamos lo que obtenemos:

defmodule Example do
  defmacro double_puts(expr) do
    quote bind_quoted: [expr: expr] do
      IO.puts(expr)
      IO.puts(expr)
    end
  end
end

iex > require Example
nil
iex > Example.double_puts(:os.system_time())
1_450_476_083_466_500_000
1_450_476_083_466_500_000

# Con bind_quoted obtenemos nuestro resultado esperado: el mismo tiempo se imprime dos veces.

# Ahora que hemos cubierto quote/2, unquote/1 y defmacro/2, tenemos todas las herramientas necesarias para extender Elixir y satisfacer nuestras necesidades.
