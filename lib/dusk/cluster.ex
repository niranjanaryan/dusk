defmodule Dusk.Cluster do
  @moduledoc """
  Supervisor: Zenoh client to a `zenohd` broker.

      {Dusk, connect: "tcp/127.0.0.1:7447", key: "dusk/cluster/**"}
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
    :telemetry.execute([:dusk, :cluster, :init], %{system_time: System.system_time()}, %{})
    Supervisor.init([{Dusk.Zenoh, opts}], strategy: :one_for_one)
  end
end
