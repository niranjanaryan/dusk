defmodule Dusk do
  @moduledoc """
  Zenoh **brokered** cluster for Elixir. Nodes are clients; `zenohd` is the broker.

  Not HTTP (that is [Gale](https://github.com/niranjanaryan/gale)).
  Not Iroh (that is [Ingot](https://github.com/niranjanaryan/ingot)).

      {:dusk, "~> 0.1"}
      {:zenohex, "~> 0.10"}

      {Dusk, connect: "tcp/127.0.0.1:7447", key: "dusk/cluster/**"}

  Zig NIF: `key_match/2`, `hash64/1`. Wire protocol: optional `zenohex`.
  """

  defdelegate start_link(opts), to: Dusk.Cluster
  defdelegate child_spec(opts), to: Dusk.Cluster

  def key_match(pat, key) when is_binary(pat) and is_binary(key) do
    Dusk.Native.key_match(pat, key)
  end

  def hash64(bin) when is_binary(bin), do: Dusk.Native.hash64(bin)

  def nif_loaded? do
    Dusk.Native.key_match("a", "a") == true
  rescue
    _ -> false
  end

  def backends do
    %{zenoh: Dusk.Zenoh.available?(), zig_nif: nif_loaded?()}
  end
end
