# Debería tenerse en cuenta que en Elixir, los únicos valores falsos son nil y el booleano false.

# if else
if String.valid?("Hello") do
  "Valid string!"
else
  "Invalid string"
end

# "Valid string!"

if "a string value" do
  "Truthy"
end

# "Truthy"

# unless
# Usar unless/2 es como if/2 solo que trabaja en forma inversa:
unless is_integer("hello") do
  "Not an Int"
end

# "Not an Int"
