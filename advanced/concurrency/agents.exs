# Agents

# Los agentes son una abstracción en torno a los procesos de fondo que mantienen el estado. Podemos acceder a ellos desde otros procesos dentro de nuestra aplicación y nodo. El estado de nuestro agente se establece en el valor de retorno de nuestra función:

{:ok, agent} = Agent.start_link(fn -> [1, 2, 3] end)
{:ok, #PID<0.65.0>}

Agent.update(agent, fn (state) -> state ++ [4, 5] end)
:ok

Agent.get(agent, &(&1))
[1, 2, 3, 4, 5]

# Cuando nombramos un Agente, podemos referirnos a él por eso en lugar de su PID:
Agent.start_link(fn -> [1, 2, 3] end, name: Numbers)
{:ok, #PID<0.74.0>}

Agent.get(Numbers, &(&1))
[1, 2, 3]
