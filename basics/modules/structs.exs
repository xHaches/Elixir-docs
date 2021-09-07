# Structs
# Las estructuras son maps especiales con un conjunto definido de claves y valores por defecto. Deben ser definidas dentro de un módulo, y tomarán su nombre. Es común que una estructura sea definida únicamente dentro de un módulo.

# Para definir una estructura utilizamos defstruct junto con una lista de claves y valores por defecto:
defmodule Example.User do
  defstruct name: "Sean", roles: []
end

# Ahora creemos estructuras
%Example.User{}
%Example.User<name: "Sean", roles: [], ...>

%Example.User{name: "Steve"}
%Example.User<name: "Steve", roles: [], ...>

%Example.User{name: "Steve", roles: [:manager]}
%Example.User<name: "Steve", roles: [:manager]>

# Podemos actualizar una estructura justo como lo hacemos con un mapa:

steve = %Example.User{name: "Steve"}
%Example.User<name: "Steve", roles: [...], ...>
sean = %{steve | name: "Sean"}
%Example.User<name: "Sean", roles: [...], ...>

# Algo muy importante es que podemos hacer coincidencia entre estructuras y mapas:

%{name: "Sean"} = sean
%Example.User<name: "Sean", roles: [...], ...>

# A partir de Elixir 1.8 las estructuras incluyen la inspección personalizada. Para entender que significa esto y cómo debemos usarlo, debemos inspeccionar el mapa sean:

inspect(sean)
"%Example.User<name: \"Sean\", roles: [...], ...>"

# Todos nuestros campos están presentes, lo que esta bien para este ejemplo, pero ¿qué pasaría si tuviéramos un campo protegido que no quisiéramos incluir? ¡La nueva característica @derive nos permite lograr esto! Actualicemos nuestro ejemplo para que roles ya no sea incluido en la salida:
defmodule Example.User do
  @derive {Inspect, only: [:name]}
  defstruct name: nil, roles: []
end

# Nota: también podríamos usar @derive {Inspect, except: [:roles]}, son equivalentes.

# Con nuestro módulo actualizado, echemos un vistazo:
sean = %Example.User<name: "Sean", roles: [...], ...>
%Example.User<name: "Sean", ...>
inspect(sean)
"%Example.User<name: \"Sean\", ...>"
# Los roles son excluidos de la salida.
