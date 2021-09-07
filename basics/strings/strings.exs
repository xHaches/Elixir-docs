# Strings
# Los strings no son más que una secuencia de bytes. Veamos un ejemplo
string = <<104, 101, 108, 108, 111>>
"hello"
string <> <<0>>
<<104, 101, 108, 108, 111, 0>>

# Concatenando la cadena con el byte 0, IEx muestra la cadena como un binario porque ya no es una cadena válida. Este truco puede ayudarnos a ver los bytes subyacentes de cualquier cadena.

# NOTA: Usando la sintaxis «» le estamos diciendo al compilador que los elementos dentro de esos símbolos son bytes.
