# Filtrado
# Por defecto, todas las funciones y macros son importadas, pero podemos filtarlas utilizando las opciones :only y :except Empecemos por importar únicamente la función last/1

import List, only: [last: 1]
first([1, 2, 3])
# ** (CompileError) iex:13: undefined function first/1
last([1, 2, 3])
3

# Si importamos todo excepto last/1 e intentamos utilizar la misma función:

import List, except: [last: 1]
first([1, 2, 3])
1
last([1, 2, 3])
# ** (CompileError) iex:3: undefined function last/1

# En adición a los pares nombre/aridad, hay dos átomos especiales, :functions y :macros, las cuales importan únicamente funciones y macros, respectivamente:
import List, only: :functions
import List, only: :macros
