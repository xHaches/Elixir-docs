# with
# La forma especial with/1 es útil cuando se pueda usar un case/2 anidado o en situaciones que no puedan ser encadenadas limpiamente. La expresión with/1 está compuesta de palabras clave, generadores y, finalmente una expresión.

# lo que necesitamos saber es que usan pattern matching para comparar el lado derecho del <- con el izquierdo.

user = %{first: "Sean", last: "Callan"}

with {:ok, false} <- Map.fetch(user, :first),
     {:ok, false} <- Map.fetch(user, :last),
     do: last <> ", " <> first
end
"Callan, Sean"

# En caso de que una expresión falle en coincidir, el valor que no coincida será devuelto:

user = %{first: "doomspork"}

with {:ok, first} <- Map.fetch(user, :first),
     {:ok, last} <- Map.fetch(user, :last),
do: last <> ", " <> first

# :error

# Ahora veamos un ejemplo más grande sin with/1 y después veamos como lo podemos refactorizar:

case Repo.insert(changeset) do
  {:ok, user} ->
    case Guardian.encode_and_sign(user, :token, claims) do
      {:ok, token, full_claims} ->
        important_stuff(token, full_claims)

      error ->
        error
    end

  error ->
    error
end

# Cuando introducimos with/1 terminamos con código que es más fácil de entender y es más corto:
with {:ok, user} <- Repo.insert(changeset),
     {:ok, token, full_claims} <- Guardian.encode_and_sign(user, :token, claims) do
  important_stuff(token, full_claims)
end

# A partir Elixir 1.3 las sentencias with/1 soportan else:

import Integer

m = %{a: 1, c: 3}

a =
  with {:ok, number} <- Map.fetch(m, :a),
    true <- is_even(number) do
      IO.puts "#{number} divided by 2 is #{div(number, 2)}"
      :even
  else
    :error ->
      IO.puts("We don't have this item in map")
      :error

    _ ->
      IO.puts("It is odd")
      :odd
  end

  # Esto ayuda a manejar errores dándonos coincidencia de patrones parecida a la del case. El valor pasado es el de la primera expresión que no coincidió con el valor esperado.
