defmodule Dusk.Stacks.Bootnodes do
  @moduledoc """
  Generate `p2p.bootnodes` for `stacks-node.toml`.

  Takes discovered peers and formats them as `p2p.bootnodes` entries
  that can be dropped directly into Stacks node configuration.
  """

  @doc """
  Generate `p2p.bootnodes` TOML entries from a list of peer info maps.

  Each peer map should contain `:peer_id`, `:ip`, and `:port`.
  """
  def generate(peers) when is_list(peers) do
    peers
    |> Enum.filter(&valid_peer?/1)
    |> Enum.map(&bootnode_entry/1)
    |> Enum.join(",\n  ")
  end

  defp valid_peer?(%{ip: ip, port: port, peer_id: peer_id})
       when is_binary(ip) and is_integer(port) and is_binary(peer_id) do
    true
  end

  defp valid_peer?(_), do: false

  defp bootnode_entry(%{ip: ip, port: port, peer_id: peer_id}) do
    "{addr = \"#{ip}:#{port}\", public_key_hash = \"#{peer_id}\"}"
  end
end
