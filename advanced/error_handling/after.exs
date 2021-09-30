# After

# A veces, puede ser necesario realizar alguna acción después de nuestro intento / rescate, independientemente del error. Para esto tenemos try / after. Si está familiarizado con Ruby, esto es similar a begin/rescue/ensure o en Java try/ catch/finally:

iex> try do
  ...>   raise "Oh no!"
  ...> rescue
  ...>   e in RuntimeError -> IO.puts("An error occurred: " <> e.message)
  ...> after
  ...>   IO.puts "The end!"
  ...> end
An error occurred: Oh no!
The end!
:ok

# Esto se usa más comúnmente con archivos o conexiones que deben cerrarse:

{:ok, file} = File.open("example.json")

try do
  # Do hazardous work
after
  File.close(file)
end
