# Dusk

Zenoh **brokered** cluster for Elixir. Short name, horizon-at-sundown.

```
gale   — Phoenix HTTP/3
ingot  — Iroh + Zenoh
dusk   — Zenoh + Iroh
```

```elixir
{:dusk, "~> 0.1"}
{:zenohex, "~> 0.10"}

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
remote boot). Eval: [zeiroh/EVAL.md](../zeiroh/EVAL.md).

Storage: `Dusk.Storage.put/2` (`:memory`, `:s3`, `:s5`). Hashes: [HASH.md](HASH.md).
