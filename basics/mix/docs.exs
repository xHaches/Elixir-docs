# Interactive

# It may be necessary to use iex within the context of our application. Thankfully for us, Mix makes this easy. We can start a new iex session:
$ cd example
$ iex -S mix
# Starting iex this way will load your application and dependencies into the current runtime.

# Compilation
# Mix is smart and will compile your changes when necessary, but it may still be necessary to explicitly compile your project. In this section we’ll cover how to compile our project and what compilation does.

# To compile a Mix project we only need to run mix compile in our base directory: Note: Mix tasks for a project are available only from the project root directory, only global Mix tasks are available otherwise.

$ mix compile

# There isn’t much to our project so the output isn’t too exciting but it should complete successfully:

# Compiled lib/example.ex
# Generated example app

# When we compile a project, Mix creates a _build directory for our artifacts. If we look inside _build we will see our compiled application: example.app.

# Managing dependencies


# Our project doesn’t have any dependencies but will shortly, so we’ll go ahead and cover defining dependencies and fetching them.

# To add a new dependency we need to first add it to our mix.exs in the deps section. Our dependency list is comprised of tuples with two required values and one optional: the package name as an atom, the version string, and optional options.

# For this example let’s look at a project with dependencies, like phoenix_slim:

def deps do
  [
    {:phoenix, "~> 1.1 or ~> 1.2"},
    {:phoenix_html, "~> 2.3"},
    {:cowboy, "~> 1.0", only: [:dev, :test]},
    {:slime, "~> 0.14"}
  ]
end

# As you probably discerned from the dependencies above, the cowboy dependency is only necessary during development and test.

# Once we’ve defined our dependencies there is one final step: fetching them. This is analogous to bundle install:

# Like npm i
$ mix deps.get

# That’s it! We’ve defined and fetched our project dependencies. Now we’re prepared to add dependencies when the time comes.

# Environments

# Mix, much like Bundler, supports differing environments. Out of the box Mix is configured to have three environments:

# :dev — The default environment.
# :test — Used by mix test. Covered further in our next lesson.
# :prod — Used when we ship our application to production.

# The current environment can be accessed using Mix.env. As expected, the environment can be changed via the MIX_ENV environment variable:

$ MIX_ENV=prod mix compile
