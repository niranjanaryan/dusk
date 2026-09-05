defmodule Dusk.Cluster do
  @moduledoc """
  Supervisor for **Zenoh** and/or **Iroh**.

  Legacy:

      {Dusk, connect: "tcp/127.0.0.1:7447", key: "dusk/cluster/**"}

  Dual overlay:

      {Dusk, iroh: [alpns: ["dusk/1"]], zenoh: [connect: "tcp/127.0.0.1:7447"]}
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  def child_spec(opts) do
    %{
      id: Keyword.get(opts, :name, __MODULE__),
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end

  @impl true
  def init(opts) do
    iroh = Keyword.get(opts, :iroh, false)
    zenoh = zenoh_opts(opts)

    children = iroh_child(iroh) ++ zenoh_child(zenoh)

    :telemetry.execute(
      [:dusk, :cluster, :init],
      %{system_time: System.system_time()},
      %{iroh: iroh != false, zenoh: zenoh != false}
    )

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp zenoh_opts(opts) do
    cond do
      Keyword.has_key?(opts, :zenoh) -> Keyword.get(opts, :zenoh)
      Keyword.has_key?(opts, :iroh) -> false
      true -> opts
    end
  end

  defp iroh_child(false), do: []
  defp iroh_child(true), do: [{Dusk.Iroh, []}]
  defp iroh_child(opts) when is_list(opts), do: [{Dusk.Iroh, opts}]

  defp zenoh_child(false), do: []
  defp zenoh_child(true), do: [{Dusk.Zenoh, [live: false]}]
  defp zenoh_child(opts) when is_list(opts), do: [{Dusk.Zenoh, opts}]
end
