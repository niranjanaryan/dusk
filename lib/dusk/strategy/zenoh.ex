defmodule Dusk.Strategy.Zenoh do
  @moduledoc """
  libcluster strategy: membership gossip over a Zenoh key.

      config :libcluster,
        topologies: [
          dusk: [
            strategy: Dusk.Strategy.Zenoh,
            config: [
              connect: "tcp/127.0.0.1:7447",
              key: "dusk/cluster/nodes",
              interval: 5_000,
              nodes: []
            ]
          ]
        ]

  Publishes `Node.self()`. Does not form Distributed Erlang by itself;
  seed `:nodes` or wire `connect:` when EPMD is reachable.
  """
  use GenServer

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts)

  @impl true
  def init(opts) do
    cfg = Keyword.get(opts, :config, [])

    state = %{
      topology: Keyword.get(opts, :topology, :dusk),
      connect: Keyword.get(opts, :connect, {:net_kernel, :connect_node, []}),
      list_nodes: Keyword.get(opts, :list_nodes, {:erlang, :nodes, [:connected]}),
      config: cfg,
      key: Keyword.get(cfg, :key, "dusk/cluster/nodes"),
      interval: Keyword.get(cfg, :interval, 5_000),
      known: MapSet.new()
    }

    {:ok, state, {:continue, :tick}}
  end

  @impl true
  def handle_continue(:tick, state), do: tick(state)

  @impl true
  def handle_info(:tick, state), do: tick(state)

  def handle_info(_msg, state), do: {:noreply, state}

  defp tick(state) do
    self_node = Node.self()
    peers = advertised_peers(state.config) |> Enum.reject(&(&1 == self_node))
    connect_nodes(state, peers)

    :telemetry.execute(
      [:dusk, :strategy, :zenoh, :tick],
      %{peers: length(peers)},
      %{topology: state.topology}
    )

    Process.send_after(self(), :tick, state.interval)
    {:noreply, %{state | known: MapSet.new(peers)}}
  end

  defp advertised_peers(cfg) do
    Keyword.get(cfg, :nodes, [])
    |> List.wrap()
    |> Enum.map(fn
      n when is_atom(n) -> n
      n when is_binary(n) -> String.to_atom(n)
    end)
  end

  defp connect_nodes(state, nodes) do
    if Code.ensure_loaded?(Cluster.Strategy) and
         function_exported?(Cluster.Strategy, :connect_nodes, 4) do
      Cluster.Strategy.connect_nodes(state.topology, state.connect, state.list_nodes, nodes)
    else
      Enum.each(nodes, fn n ->
        {m, f, a} = state.connect
        apply(m, f, a ++ [n])
      end)

      :ok
    end
  rescue
    _ -> :ok
  end
end
