# Dusk Consumer Awareness

## Target Audience

| Segment | Who they are | Why they care |
|---------|-------------|---------------|
| PoX-5 Stackers | Run signer nodes across regions | Resilient peer discovery without static configs |
| sBTC relay operators | Fault-tolerant coordination | Zenoh pub/sub replaces centralized brokers |
| dApp developers | Distributed indexers/monitors | FLAME-compatible cluster backend |
| DevOps teams | Stacks infrastructure at scale | Self-healing P2P data plane |

## Awareness Channels

### Stacks Ecosystem
- **Stacks Forum:** P2P discovery tutorial, cluster topology examples
- **Stacks Discord:** Q&A, demos, office hours
- **Stacks GitHub:** Issues, discussions, PRs

### Elixir Ecosystem
- **Elixir Forum:** "Zenoh + Iroh for Stacks networking"
- **Hex.pm:** Package description, docs, changelogs
- **GitHub:** Issues, discussions, stars, forks

### Social Media
- **Twitter/X:** Demo videos, benchmark screenshots
- **Reddit r/elixir:** Cross-post tutorials
- **YouTube:** Full demo screencast

## Content Strategy

### Blog Posts / Tutorials
1. **"P2P Node Discovery for Stacks with Dusk"**
   - Iroh DHT setup for Stacks nodes
   - `dusk stacks peers` CLI walkthrough
   - Auto-generating `p2p.bootnodes` for `stacks-node.toml`
   - Target: PoX-5 Stackers

2. **"Running a Distributed Stacks Indexer with Dusk + Crucible"**
   - Distributed block indexer example
   - FLAME backend for Stacks overlay
   - Cross-cloud worker provisioning
   - Target: dApp developers

3. **"sBTC Relay Coordination with Zenoh Pub/Sub"**
   - Zenoh topics for relay status
   - Relay status aggregation
   - Conflict detection patterns
   - Target: sBTC relay operators

### Demo Videos
- **5 min:** Dusk peer discovery demo
- **5 min:** Distributed Stacks indexer with FLAME

### Benchmark Publications
- `benchmark/DISCOVERY_LATENCY.md` — Iroh DHT lookup times
- `benchmark/CLUSTER_THROUGHPUT.md` — Zenoh pub/sub message rates

## Adoption Metrics

| Metric | Baseline | 30-day target | 90-day target |
|--------|----------|---------------|---------------|
| Hex downloads | 0 | 150+ | 800+ |
| GitHub stars | 0 | 30+ | 150+ |
| Stacks Forum replies | 0 | 5+ | 20+ |
| Blog post views | 0 | 400+ | 1,500+ |
| Demo video views | 0 | 150+ | 800+ |

## Timeline

### Week 1-2
- [ ] Publish P2P discovery tutorial
- [ ] Post Stacks Forum thread
- [ ] Record peer discovery demo

### Week 3-4
- [ ] Publish distributed indexer tutorial
- [ ] Post Elixir Forum thread
- [ ] Submit Reddit r/elixir cross-post

### Week 5-8
- [ ] Publish sBTC relay coordination guide
- [ ] Monitor and respond to feedback
- [ ] Update benchmarks

## Key Messages

**For Stacks operators:**
> "Eliminate single-point-of-failure peer discovery. Dusk gives you a self-healing P2P data plane for Stacks nodes and relays."

**For Elixir developers:**
> "The only Elixir package combining Zenoh brokered pub/sub with Iroh P2P QUIC. FLAME-compatible cluster backend for distributed workers."

## Competitive Positioning

| Competitor | Gap we fill |
|------------|-------------|
| Static peer lists | Iroh DHT-based auto-discovery |
| Centralized message brokers | Zenoh pub/sub without central broker |
| Generic libp2p wrappers | Phoenix/FLAME integration, Stacks-specific |
| Single-language tools | Elixir-native, BEAM-optimized |

**Our advantage:** Only Elixir package combining Zenoh + Iroh + FLAME in a single cluster backend designed for Stacks.

---

*This document is part of the Elixir Distributed Stack consumer awareness strategy.*
