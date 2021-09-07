# binario
0b01110
# octal
0o644
# hex
0x1F

# float
3.14
# error
# .14
# exponenciales
1.0e-10

# booleano
true
false
true
false

# atomos: constante cuyo nombre es su valor Los booleanos true y false son también los átomos :true y :false respectivamente.
:foo

is_atom(true)
# true
is_boolean(true)
# true
true === true
# true

# los nombres de modulos en elixir tambien son atomos un átomo válido, incluso si el módulo no ha sido declarado aún.
is_atom(MyApp.MyModule)
# true

# Operaciones
# Aritmeticas
# +, -, *, / la division siempre devuelve un float
# si deseas un entero como resultado de una division usa:
div(10, 5)
# 2
# residuio de la division, conserva el signo del primer argumento
rem(10, 3)
# 1
rem(-10, 3)
# -1

# Booleanas
# ||, &&, ! para valores truthy o falsy
# and, or, not, para valores true o false

# Comparacion

# ==, !=, ===, !==, <=, >=, <, y >.

# Una característica importante de Elixir es que cualquier par de tipos se pueden comparar, esto es útil particularmente en ordenación. No necesitamos memorizar el orden pero es importante ser consciente de este:

# number < atom < reference < function < port < pid < tuple < map < list < bitstring

# Interpolacion de cadenas
name = "luis"
"Hola #{name}"
# Hola luis

# Concatenacion de cadenas
"Hello " < name>
# Hello luis
