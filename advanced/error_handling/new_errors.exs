# New Errors
# Si bien Elixir incluye varios tipos de errores incorporados como RuntimeError, mantenemos la capacidad de crear el nuestro si necesitamos algo específico. Crear un nuevo error es fácil con la macro defexception/1 que acepta convenientemente la opción: message para establecer un mensaje de error predeterminado:

defmodule ExampleError do
  defexception message: "An example error has ocurred"
end

# Probando el nuevo error
try do
  raise ExampleError
rescue
  e in ExampleError -> e
end

%ExampleError{message: "an example error has occurred"}
