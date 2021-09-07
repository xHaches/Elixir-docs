# Time
# Elixir tiene algunos módulos que trabajan con tiempo. Vamos a empezar obteniendo la hora actual
Time.utc_now()
~T[14:28:00.056226]

# Notar que tenemos un sigil, el cual también puede ser usado para crear una estructura de Time

t = ~T[14:28:00.056226]

t.hour
14

t.minute
28

t.day
# ** (KeyError) key :day not found in: ~T[19:39:31.056226]

# Pero hay un problema: como habrás notado, esta estructura solo contiene la hora dentro de un día, no hay datos de día / mes / año.

# Date
# Contrario a Time, una struct Date tiene información sobre la fecha actual, sin información del tiempo actual.

Date.utc_today()
~D[2021-10-21]

# Y tiene algunas funciones útiles para trabajar con fechas:

{:ok, date} = Date.new(2020, 12, 12)
{:ok, ~D[2020-12-12]}
Date.day_of_week(date)
6
Date.leap_year?(date)
true

# day_of_week / 1 calcula en qué día de la semana se encuentra una fecha determinada. En este caso es sábado. leap_year? / 1 comprueba si se trata de un año bisiesto. Otras funciones se pueden encontrar en doc.

# NaiveDateTime

# Hay dos tipos de estructuras que contienen fecha y hora a la vez en Elixir. El primero es NaiveDateTime. Su desventaja es la falta de compatibilidad con la zona horaria:
NaiveDateTime.utc_now()
~N[2029-01-21 19:55:10.008965]

# Pero tiene tanto la hora como la fecha actuales, por lo que puedes jugar agregando tiempo, por ejemplo:

NaiveDateTime.add(~N[2018-10-01 00:00:14], 30)
~N[2018-10-01 00:00:44]

# DateTime

# El segundo, como habrás adivinado por el título de esta sección, es DateTime. No tiene las limitaciones señaladas en NaiveDateTime: tiene fecha y hora, y admite zonas horarias. Pero tenga en cuenta las zonas horarias. Los documentos oficiales dicen:

# Muchas funciones de este módulo requieren una base de datos de zona horaria. De forma predeterminada, utiliza la base de datos de zona horaria predeterminada devuelta por Calendar.get_time_zone_database / 0, que por defecto es Calendar.UTCOnlyTimeZoneDatabase que solo maneja las fechas y horas "Etc / UTC" y devuelve {: error,: utc_only_time_zone_database} para cualquier otra zona horaria.

# Además, tenga en cuenta que puede crear una instancia de DateTime desde NaiveDateTime, simplemente proporcionando la zona horaria:

DateTime.from_naive(~N[2016-05-24 13:26:08.003], "Etc/UTC")
{:ok, #DateTime<2016-05-24 13:26:08.003Z>}

# Trabajando con zonas horarias
# Como vimos anteriormente, elixir no trabaja con ninguna información de zonas horarias por defecto. Para resolver este problema, necesitamos instalar el paquete:

# tzdata
# Después de instalarlo, debe configurar globalmente Elixir para usar Tzdata como base de datos de zona horaria:

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Intentemos ahora crear la hora en la zona horaria de París y convertirla a la hora de Nueva York:

paris_datetime = DateTime.from_naive!(~N[2019-01-01 12:00:00], "Europe/Paris")
#DateTime<2019-01-01 12:00:00+01:00 CET Europe/Paris>
{:ok, ny_datetime} = DateTime.shift_zone(paris_datetime, "America/New_York")
{:ok, #DateTime<2019-01-01 06:00:00-05:00 EST America/New_York>}
ny_datetime
#DateTime<2019-01-01 06:00:00-05:00 EST America/New_York>

# Como puede ver, la hora cambió de las 12:00 hora de París a las 6:00, lo cual es correcto: la diferencia horaria entre las dos ciudades es de 6 horas.

# ¡Eso es todo! Si desea trabajar con otras funciones avanzadas, puede considerar buscar más en los documentos para Time, Date, DateTime y NaiveDateTime. También debe considerar Timex y Calendar, que son bibliotecas poderosas para trabajar con el tiempo en Elixir.
