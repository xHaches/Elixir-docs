# Default Arguments
# si queremos un valor por defecto para un argumento usamos la sintaxis:
# argument \\ value

defmodule Greeter do
  def hello(name, language_code \\ "en") do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end

Greeter.hello("Sean", "en")
"Hello, Sean"

Greeter.hello("Sean")
"Hello, Sean"

Greeter.hello("Sean", "es")
"Hola, Sean"

# Si combinamos un guardia con argumentos por defecto, nos encontramos con un problema. Veamos cómo se vería esto.

defmodule Greeter do
  def hello(names, language_code \\ "en") when is_list(names) do
    names
    |> Enum.join(", ")
    |> hello(language_code)
  end

  def hello(name, language_code \\ "en") when is_binary(name) do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end

# ** (CompileError) iex:31: definitions with multiple clauses and default values require a header.
# Instead of:

#     def foo(:first_clause, b \\ :default) do ... end
#     def foo(:second_clause, b) do ... end

# one should write:

#     def foo(a, b \\ :default)
#     def foo(:first_clause, b) do ... end
#     def foo(:second_clause, b) do ... end

# def hello/2 has multiple clauses and defines defaults in one or more clauses
#     iex:31: (module)

# A Elixir no le gustan los argumentos predeterminados en múltiples matching functions, puede ser confuso. Para manejar esto, agregamos un encabezado de función con nuestros argumentos predeterminados:

defmodule Greeter do
  def hello(names, language_code \\ "en")

  def hello(names, language_code) when is_list(names) do
    names
    |> Enum.join(", ")
    |> hello(language_code)
  end

  def hello(name, language_code) when is_binary(name) do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end

iex > Greeter.hello(["Sean", "Steve"])
"Hello, Sean, Steve"

iex > Greeter.hello(["Sean", "Steve"], "es")
"Hola, Sean, Steve"
