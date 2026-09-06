defmodule Mix.Tasks.Dusk.Install do
  @moduledoc "Build escript + NIFs and install `dusk` to ~/.local/bin."
  use Mix.Task
  @shortdoc "Install the dusk CLI"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("dusk.build")
    Mix.Task.run("compile")
    Mix.Task.run("escript.build")

    bin_dir = Path.expand("~/.local/bin")
    priv_dir = Path.expand("~/.dusk/priv")
    File.mkdir_p!(bin_dir)
    File.mkdir_p!(priv_dir)

    escript = Path.join(File.cwd!(), "dusk")
    File.cp!(escript, Path.join(bin_dir, "dusk"))
    File.chmod!(Path.join(bin_dir, "dusk"), 0o755)

    app_priv = Path.join(Mix.Project.app_path(), "priv")

    if File.dir?(app_priv) do
      File.cp_r!(app_priv, priv_dir)
    end

    Mix.shell().info("installed #{Path.join(bin_dir, "dusk")}")
    Mix.shell().info("NIFs in #{priv_dir}")
    Mix.shell().info("ensure #{bin_dir} is on PATH")
  end
end
