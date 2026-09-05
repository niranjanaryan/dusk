defmodule Dusk do
  @moduledoc """
  Cluster over **Zenoh** (`zenohd`) and **Iroh** (iron / P2P QUIC).

  HTTP/3 is [Gale](https://github.com/niranjanaryan/gale).
  Twin dual-overlay package: [Ingot](https://github.com/niranjanaryan/ingot).

      {Dusk, connect: "tcp/127.0.0.1:7447", key: "dusk/cluster/**"}

      {Dusk, iroh: [alpns: ["dusk/1"]], zenoh: [connect: "tcp/127.0.0.1:7447"]}

  Zig NIF: `key_match/2`, `hash64/1`, `blake3/1`, `xxh3/1`.
  libcluster: `Dusk.Strategy.Zenoh`, `Dusk.Strategy.Iroh`.
  FLAME: `Dusk.FLAME.Backend` with `overlay: :zenoh | :iroh | :both`.
  """

  defdelegate start_link(opts), to: Dusk.Cluster
  defdelegate child_spec(opts), to: Dusk.Cluster

  def key_match(pat, key) when is_binary(pat) and is_binary(key) do
    Dusk.Native.key_match(pat, key)
  end

  def hash64(bin) when is_binary(bin), do: Dusk.Native.hash64(bin)

  def blake3(bin) when is_binary(bin), do: Dusk.Native.blake3(bin)

  def xxh3(bin) when is_binary(bin), do: Dusk.Native.xxh3(bin)

  def nif_loaded? do
    Dusk.Native.key_match("a", "a") == true
  rescue
    _ -> false
  end

  def backends do
    %{
      zenoh: Dusk.Zenoh.available?(),
      iroh: Dusk.Iroh.available?(),
      zig_nif: nif_loaded?()
    }
  end
end
