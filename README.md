# Dusk

Zenoh **brokered** cluster for Elixir. Short name, horizon-at-sundown.

```
gale   — Phoenix HTTP/3
ingot  — Iroh P2P QUIC
dusk   — Zenoh + zenohd
```

```elixir
{:dusk, "~> 0.1"}
{:zenohex, "~> 0.10"}

{Dusk, connect: "tcp/127.0.0.1:7447", key: "dusk/cluster/**"}
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
config :flame, :backend, {Dusk.FLAME.Backend, live: false}
```
