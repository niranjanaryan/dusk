defmodule Mix.Tasks.Dusk do
  @moduledoc "Dusk CLI. Same as the `dusk` escript."
  use Mix.Task
  @shortdoc "dusk backends|match|hash|put|nif"

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    Dusk.CLI.main(args, halt: false)
  end
end
