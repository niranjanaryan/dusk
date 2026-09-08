defmodule Dusk.Stacks do
  @moduledoc """
  Stacks-specific overlay for Dusk.

  Provides P2P node discovery via Iroh DHT and Zenoh pub/sub
  for Stacks signer nodes, API nodes, and sBTC relay coordination.

  ## Examples

      # Start Dusk with Stacks overlay
      {:ok, _pid} = Dusk.start_link(overlay: :stacks, backend: :iroh,
        iroh: [alpns: ["stacks/node/1", "stacks/relay/1"]])

      # Discover Stacks nodes
      {:ok, peers} = Dusk.Stacks.discover_peers()

      # Publish sBTC relay status
      {:ok, session} = Dusk.Zenoh.session("stacks/sbtc/relay/status")
      Dusk.Zenoh.publish(session, "stacks/sbtc/relay/status", %{height: 12345})

      # Subscribe to relay status
      {:ok, session} = Dusk.Zenoh.session("stacks/sbtc/relay/status")
      Dusk.Zenoh.subscribe(session, fn msg -> IO.inspect(msg) end)
  """

  alias Dusk.{Iroh, Zenoh}
  alias Dusk.Stacks.{Discovery, PeerId, Bootnodes}

  @stacks_alpns ["stacks/node/1", "stacks/relay/1"]

  @doc """
  Start Dusk with Stacks overlay configuration.
  """
  def start_link(opts) do
    backend = Keyword.get(opts, :backend, :iroh)
    iroh_opts = Keyword.get(opts, :iroh, [])
    overlay = Keyword.get(opts, :overlay, :stacks)

    case backend do
      :iroh ->
        iroh_opts = Keyword.merge(iroh_opts, alpns: @stacks_alpns, overlay: overlay)
        Dusk.Iroh.start_link(iroh_opts)

      :zenoh ->
        zenoh_opts = Keyword.merge(opts, overlay: overlay)
        Dusk.Zenoh.start_link(zenoh_opts)

      _ ->
        {:error, {:unsupported_backend, backend}}
    end
  end

  @doc """
  Discover Stacks peers via Iroh DHT.
  """
  def discover_peers(opts \\ []) do
    Discovery.discover(opts)
  end

  @doc """
  Generate a stable peer ID from a Stacks address.

  Derives a deterministic Iroh peer ID from `stx.address` so the same
  Stacks node always gets the same peer ID across restarts.
  """
  def peer_id(stx_address) when is_binary(stx_address) do
    PeerId.from_stx_address(stx_address)
  end

  @doc """
  Auto-generate `p2p.bootnodes` for `stacks-node.toml`.

  Takes discovered peers and formats them as `p2p.bootnodes` entries.
  """
  def generate_bootnodes(peers) when is_list(peers) do
    Bootnodes.generate(peers)
  end

  @doc """
  Subscribe to sBTC relay status updates via Zenoh pub/sub.

  Returns a Zenoh session that emits relay status messages.
  """
  def relay_status_subscriber do
    {:ok, session} = Zenoh.session("stacks/sbtc/relay/status")
    {:ok, session}
  end

  @doc """
  Publish sBTC relay status via Zenoh pub/sub.
  """
  def publish_relay_status(session, status) when is_map(status) do
    Zenoh.publish(session, "stacks/sbtc/relay/status", status)
  end
end
