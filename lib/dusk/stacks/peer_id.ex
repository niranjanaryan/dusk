defmodule Dusk.Stacks.PeerId do
  @moduledoc """
  Stable peer ID derivation from Stacks addresses.

  Derives a deterministic Iroh peer ID from a Stacks `stx.address`
  so the same Stacks node always gets the same peer ID across restarts.
  """

  @doc """
  Derive a peer ID from a Stacks address.

  Uses BLAKE3 hash of the address to generate a stable 32-byte peer ID.
  """
  def from_stx_address(stx_address) when is_binary(stx_address) do
    hash = :blake3.hash(to_charlist(stx_address))
    Base.encode16(hash, case: :lower)
  end

  @doc """
  Validate that a peer ID matches a Stacks address.

  Returns `true` if the peer ID was derived from the given address.
  """
  def valid?(peer_id, stx_address) when is_binary(peer_id) and is_binary(stx_address) do
    expected = from_stx_address(stx_address)
    peer_id == expected
  end
end
