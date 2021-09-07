# use
# Con el macro use podemos habilitar otro módulo para modificar la definición de nuestro módulo actual. Cuando llamamos use en nuestro código, en realidad estamos invocando el callback __using__/1 definido por el módulo utilizado. El resultado de __using__/1 se convierte en parte de la definición de nuestro módulo. Para comprender mejor cómo funciona esto, veamos un ejemplo simple:

defmodule Hello do
  defmacro __using__(_opts) do
    quote do
      def hello(name), do: "Hi, #{name}"
    end
  end
end

# Aquí hemos creado un módulo Hello que define el callback __using__/1 dentro del cual definimos una función hello/1. Vamos a crear un nuevo módulo para que podamos probar nuestro nuevo código:

defmodule Example do
  use Hello
end

# Si probamos nuestro código, veremos que hello/1 esta disponible en el módulo Example:

Example.hello("Sean")
# "Hi, Sean"

# Aquí podemos ver que use invocó el callback __using__/1 del módulo Hello que a su ves agrego el código resultante a nuestro módulo. Ahora que hemos demostrado un ejemplo básico, actualicemos nuestro código para ver cómo __using__/1 admite opciones. Haremos esto agregando la opción greeting:
defmodule Hello do
  defmacro __using__(opts) do
    greeting = Keyword.get(opts, :greeting, "Hi")

    quote do
      def hello(name), do: unquote(greeting) <> ", " <> name
    end
  end
end

# Actualicemos nuestro módulo Example para incluir la opción greeting recién creada:
defmodule Example do
  use Hello, greeting: "Hola"
end

Example.hello("Sean")
"Hola, Sean"

# Estos son ejemplos simples para mostrar como funciona use, pero es una herramienta increíblemente poderosa en las herramientas de Elixir. A medida que continúe aprendiendo acerca de Elixir, este atento a use, un ejemplo que seguramente vera es use ExUnit.Case, async: true.

# Nota: quote, alias, use, require son macros utilizadas cuando trabajamos con metaprogramming.
