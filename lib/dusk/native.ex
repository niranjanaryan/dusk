defmodule Dusk.Native do
  @moduledoc "Zig NIF: Zenoh key-expr match and FNV-1a hash64."

  @on_load :load_nif

  def load_nif do
    Enum.find_value(nif_candidates(), fn path ->
      case :erlang.load_nif(String.to_charlist(path), 0) do
        :ok -> true
        {:error, _} -> false
      end
    end)

    :ok
  rescue
    _ -> :ok
  end

  defp nif_candidates do
    _ = Code.ensure_loaded(Dusk.CLI.Paths)

    app =
      case :code.priv_dir(:dusk) do
        {:error, _} -> []
        dir -> [Path.join(dir, "dusk_nif")]
      end

    env = System.get_env("DUSK_PRIV")
    env = if env, do: [Path.join(env, "dusk_nif")], else: []

    app ++
      env ++
      Dusk.CLI.Paths.nif_dirs(:dusk, "dusk_nif") ++ [Path.expand("../../priv/dusk_nif", __DIR__)]
  end

  def key_match(_pat, _key), do: :erlang.nif_error(:nif_not_loaded)
  def hash64(_bin), do: :erlang.nif_error(:nif_not_loaded)
  def blake3(_bin), do: :erlang.nif_error(:nif_not_loaded)
  def xxh3(_bin), do: :erlang.nif_error(:nif_not_loaded)
end
