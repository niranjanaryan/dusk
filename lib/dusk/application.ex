defmodule Dusk.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    maybe_cli()
    Supervisor.start_link([], strategy: :one_for_one, name: Dusk.Supervisor)
  end

  defp maybe_cli do
    if System.get_env("RELEASE_NAME") == "dusk" do
      args = :init.get_plain_arguments() |> Enum.map(&List.to_string/1)
      Dusk.CLI.main(args, halt: true)
    end
  end
end
