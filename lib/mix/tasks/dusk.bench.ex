defmodule Mix.Tasks.Dusk.Bench do
  @moduledoc false
  use Mix.Task
  @shortdoc "Zig NIF vs Elixir key-expr match + BLAKE3/XXH3"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")
    unless Dusk.nif_loaded?(), do: Mix.raise("Zig NIF not loaded")

    iters = 80_000
    pat = "dusk/cluster/**"
    key = "dusk/cluster/us-east/node-1"

    {zig_us, _} = :timer.tc(fn -> for _ <- 1..iters, do: Dusk.key_match(pat, key) end)
    {elx_us, _} = :timer.tc(fn -> for _ <- 1..iters, do: Dusk.Elixir.key_match(pat, key) end)
    zig = iters * 1_000_000 / zig_us
    elx = iters * 1_000_000 / elx_us

    n = 20_000
    blob = :crypto.strong_rand_bytes(1024)
    {b3_us, _} = :timer.tc(fn -> for _ <- 1..n, do: Dusk.blake3(blob) end)
    {x_us, _} = :timer.tc(fn -> for _ <- 1..n, do: Dusk.xxh3(blob) end)
    b3 = n * 1024 / 1_048_576 / (b3_us / 1_000_000)
    xx = n * 1024 / 1_048_576 / (x_us / 1_000_000)

    body = """
    # Dusk bench

    Machine: #{:erlang.system_info(:system_architecture)} OTP #{:erlang.system_info(:otp_release)}
    Date: #{Date.utc_today()}

    | op | rate |
    | --- | ---: |
    | key_match Elixir | #{round(elx)} /s |
    | key_match Zig | #{round(zig)} /s (#{Float.round(zig / elx, 2)}×) |
    | blake3 1 KiB | #{:erlang.float_to_binary(b3, decimals: 1)} MiB/s |
    | xxh3 1 KiB | #{:erlang.float_to_binary(xx, decimals: 1)} MiB/s |
    """

    File.mkdir_p!("benchmark")
    File.write!("benchmark/RESULTS.md", body)
    Mix.shell().info(body)
  end
end
