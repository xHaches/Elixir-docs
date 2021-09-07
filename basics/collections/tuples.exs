# Tuplas
# Similares a las listas, pero son almacenadas de manera contigua. Esto permite acceder a su longitud de forma rápida, pero hace su modificación costosa; debido a que la nueva tupla debe ser copiada de nuevo en la memoria. Las tuplas son definidas mediante el uso de llaves:

{3.14, :pie, "Apple"}

# Común como mecanismo que retorna información adicional de funciones
defmodule Functions do
  def getData do
    {:ok, "Hola", "otro dato"}
  end
end

IO.inspect(Functions.getData())
