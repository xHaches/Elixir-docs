# require
# Aunque require/2 no es usado frecuentemente, es bastante importante. Haciendo require de un módulo asegura que está compilado y cargado. Esto es muy útil cuando necesitamos acceso a las macros de un módulo:
defmodule Example do
  require SuperMacros
  SuperMacros.do_stuff()
end

# Si intentamos hacer un llamado a una macro que no está cargada aún, Elixir lanzará un error.
