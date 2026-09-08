# Dusk

[![Hex.pm](https://img.shields.io/hexpm/v/dusk.svg)](https://hex.pm/packages/dusk)
[![Hexdocs](https://img.shields.io/badge/hex-docs-purple.svg)](https://hexdocs.pm/dusk)
[![CI](https://github.com/niranjanaryan/dusk/actions/workflows/ci.yml/badge.svg)](https://github.com/niranjanaryan/dusk/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Sponsor](https://img.shields.io/badge/sponsor-GitHub-ea4aaa.svg)](https://github.com/sponsors/niranjanaryan)
[![Hex.pm downloads](https://img.shields.io/hexpm/dt/dusk.svg)](https://hex.pm/packages/dusk)

## Funding

If you find Dusk useful, please consider sponsoring to support ongoing development:

- **[GitHub Sponsors](https://github.com/sponsors/niranjanaryan)** — direct support
- See [FUNDING.md](FUNDING.md) for related projects and why funding matters.

---

Zenoh **brokered** cluster for Elixir. Short name, horizon-at-sundown.

```
gale   — Phoenix HTTP/3
ingot  — Iroh + Zenoh (Hex: `ingot_cluster`)
dusk   — Zenoh + Iroh
orian  — BLAKE3 / S3 / S5 storage
zeiroh — Phoenix FLAME overlay
```

```elixir
{:dusk, "~> 0.1"}
{:zenohex, "~> 0.10"}
```

```bash
mix dusk.install
# prefers a Burrito single binary (ERTS inside); else Mix escript
# mix dusk.binary   # burrito_out/dusk_<os>
# Linux/macOS: ~/.local/bin    Windows: %LOCALAPPDATA%\elixcoder\bin
dusk backends
dusk match "a/**" a/b
dusk hash ./file --algo blake3
dusk put ./file
```

Inside a Mix project: `mix dusk backends`.

```elixir
{Dusk, connect: "tcp/127.0.0.1:7447", key: "dusk/cluster/**"}

{Dusk, iroh: [alpns: ["dusk/1"]], zenoh: [connect: "tcp/127.0.0.1:7447"]}
```

```bash
zenohd --listen tcp/0.0.0.0:7447
```

Zig NIF for key-expr match. MIT. [github.com/niranjanaryan/dusk](https://github.com/niranjanaryan/dusk)

## libcluster

```elixir
config :libcluster,
  topologies: [
    dusk: [
      strategy: Dusk.Strategy.Zenoh,
      config: [connect: "tcp/127.0.0.1:7447", key: "dusk/cluster/nodes"]
    ]
  ]
```

## Phoenix FLAME

```elixir
config :libcluster,
  topologies: [
    dusk_iroh: [strategy: Dusk.Strategy.Iroh, config: [alpns: ["dusk/1"]]]
  ]

config :flame, :backend, {Dusk.FLAME.Backend, overlay: :both, live: false}
```

**Limits:** local spawn loop, not elastic FLAME (`FLAME.Terminator` /
remote boot). Eval: [EVAL.md](https://github.com/niranjanaryan/zeiroh/blob/main/EVAL.md). Scaling:
[SCALING.md](https://github.com/niranjanaryan/zeiroh/blob/main/SCALING.md).

Storage: `Dusk.Storage.put/2` (`:memory`, `:s3`, `:s5`). Hashes: [HASH.md](HASH.md).
