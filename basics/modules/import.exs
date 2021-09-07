# import
# Si queremos importar las funciones y macros de un módulo, más que sólo darle un alias, podemos utilizar import/:
last([1, 2, 3])
# ** (CompileError) iex:9: undefined function last/1
import List
last([1, 2, 3])
# 3
