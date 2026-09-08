defmodule Mix.Tasks.Dusk.Install do
  @moduledoc "Install dusk: Burrito single binary if possible, else escript."
  use Mix.Task
  @shortdoc "Install the dusk CLI (single binary or escript)"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")

    case maybe_burrito() do
      {:ok, src} ->
        dest = Dusk.CLI.Paths.install_bin(src, "dusk")
        Mix.shell().info("installed single binary #{dest}")

      :error ->
        Mix.Task.run("dusk.build")
        Mix.Task.run("escript.build")
        dest = Dusk.CLI.Paths.install_escript("dusk")
        priv = Dusk.CLI.Paths.copy_priv(:dusk)
        Mix.shell().info("installed escript #{dest} (needs escript on PATH)")
        Mix.shell().info("NIFs in #{priv}")
        Mix.shell().info("for a single binary: zig 0.15 + xz, then mix dusk.binary")
    end

    Mix.shell().info("bin dir #{Dusk.CLI.Paths.bin_dir()}")
  end

  defp maybe_burrito do
    Mix.Task.run("dusk.binary")

    case Path.wildcard("burrito_out/dusk_*") do
      [f | _] -> {:ok, f}
      _ -> :error
    end
  rescue
    e ->
      Mix.shell().error("burrito: #{Exception.message(e)}")
      :error
  end
end
