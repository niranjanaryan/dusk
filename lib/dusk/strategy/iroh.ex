defmodule Dusk.Strategy.Iroh do
  @moduledoc """
  libcluster strategy: membership over **Iroh** (iron / P2P QUIC).

      config :libcluster,
        topologies: [
          dusk_iroh: [
            strategy: Dusk.Strategy.Iroh,
            config: [interval: 5_000, alpns: ["dusk/1"]]
          ]
        ]
  """
  use GenServer

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts)

  @impl true
  def init(opts) do
    cfg = Keyword.get(opts, :config, [])

    state = %{
      topology: Keyword.get(opts, :topology, :dusk_iroh),
      connect: Keyword.get(opts, :connect, {:net_kernel, :connect_node, []}),
      list_nodes: Keyword.get(opts, :list_nodes, {:erlang, :nodes, [:connected]}),
      config: cfg,
      interval: Keyword.get(cfg, :interval, 5_000)
    }

    _ = maybe_start_iroh(cfg)
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
    Process.send_after(self(), :tick, state.interval)
    {:noreply, state}
  end

  defp maybe_start_iroh(cfg) do
    if Process.whereis(Dusk.Iroh) do
      :ok
    else
      case Dusk.Iroh.start_link(alpns: Keyword.get(cfg, :alpns, ["dusk/1"])) do
        {:ok, _} -> :ok
        {:error, {:already_started, _}} -> :ok
        _ -> :ok
      end
    end
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
    end
  rescue
    _ -> :ok
  end
end
