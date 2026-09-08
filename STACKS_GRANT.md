# Stacks Endowment Grant Application — Dusk Stacks Cluster

**Track:** Getting Started Grant  
**Theme:** Distribution & Integrations (Q3 2026)  
**Request:** $4,500 STX  
**Timeline:** 8 weeks  

---

## 1. Project Summary

**Dusk** is a Zenoh + Iroh cluster for Elixir with BLAKE3/S5/S3 storage. We are requesting a Getting Started Grant to add a **Stacks-specific cluster backend** that enables distributed Stacks node communication, off-chain service orchestration, and sBTC relay data exchange — all from Elixir.

Today, Stacks node operators and sBTC relay operators rely on centralized APIs, static peer lists, or manual networking configuration. There is no language-native, FLAME-compatible cluster backend that treats Stacks infrastructure as a first-class citizen. Dusk fills this gap by providing Zenoh/Iroh-backed node-to-node communication that can run alongside existing Stacks tooling.

**Why Stacks:** As PoX-5, sBTC, and the Nakamoto upgrade scale, Stacks operators need resilient, low-latency node networking that doesn't depend on a single relay or static config. Dusk gives them a self-healing P2P data plane written in Elixir, composable with any Stacks backend.

---

## 2. Problem Statement

Stacks infrastructure networking is centralized and fragile:

- **Static peer lists**: Node operators manually configure `peers` in `stacks-node.toml`. If a peer goes down, discovery halts.
- **Centralized RPC**: dApps and relays hit a single API endpoint. No built-in replication or failover.
- **No P2P data plane**: Block propagation, transaction gossip, and sBTC relay coordination rely on TCP gossip protocols that are hard to operate behind NAT or in multi-region setups.
- **Off-chain services**: Stacks dApps that need distributed workers (indexers, relay monitors, fraud detectors) have no standard FLAME-compatible overlay.

**The gap:** No Elixir-native cluster backend designed for Stacks node and relay communication. Existing options are generic libp2p wrappers or single-language tools that don't integrate with Phoenix/FLAME.

---

## 3. Solution

Dusk adds a `Dusk.Stacks` backend that provides:

1. **P2P node discovery** — Iroh-based DHT for Stacks signer and API node discovery. Nodes advertise their IP, port, and version without a central tracker.
2. **Zenoh pub/sub for Stacks services** — Use Dusk's Zenoh backend for distributed off-chain workers (indexers, relay monitors, fraud watchers) that auto-discover each other.
3. **sBTC relay data plane** — Zenoh pub/sub for relay-to-relay Bitcoin/Stacks state synchronization, replacing or complementing centralized message queues.

```elixir
# Stacks node with P2P discovery
{Dusk, overlay: :stacks, backend: :iroh,
  iroh: [alpns: ["stacks/node/1", "stacks/relay/1"]]}

# Distributed Stacks indexer
{FLAME.Pool,
  name: StacksIndexer,
  backend: {Dusk.FLAME.Backend,
    overlay: :stacks,
    provisioner: {Crucible, driver: :hetzner}}}

# sBTC relay pub/sub
{:ok, session} = Dusk.Zenoh.session("stacks/sbtc/relay/**")
Dusk.Zenoh.publish(session, "stacks/sbtc/relay/status", %{height: 12345})
```

CLI parity:

```bash
dusk stacks peers          # discover Stacks nodes via Iroh DHT
dusk stacks relay-status   # subscribe to sBTC relay status via Zenoh
dusk flame --overlay stacks # spawn FLAME workers with Stacks overlay
```

**Design choices:**
- Backward-compatible: existing Dusk users unaffected; Stacks overlay is opt-in via `overlay: :stacks`.
- Interoperable: Iroh and Zenoh both speak QUIC, so Stacks nodes can communicate across firewalls.
- Composable: works with Crucible for provisioning, Gale for HTTP transport, and existing Stacks node binaries.

---

## 4. Why This Matters for Stacks

**Ecosystem impact:**
- Eliminates single-point-of-failure peer discovery for Stacks node operators.
- Enables geo-redundant sBTC relay networks without centralized message brokers.
- Gives Stacks dApp developers a standard way to run distributed off-chain workers (indexers, monitors) using Phoenix FLAME + Elixir.

**Strategic alignment:**
- Directly supports the Nakamoto-upgraded network by improving node resilience and discovery.
- Enables sBTC utility by providing a peer-to-peer relay coordination layer.
- Fits the Q3 2026 "Distribution & Integrations" theme: infrastructure that connects Stacks nodes, relays, and dApps in a distributed, fault-tolerant way.

**Ecosystem-first:**
- Open-source (MIT), no token, no platform fee.
- Other Stacks projects can adopt the P2P overlay independently.
- Works with any Stacks node implementation that supports standard TCP/QUIC networking.

---

## 5. Milestones

### Milestone 1: Stacks Node Discovery via Iroh DHT (Weeks 1–3, $1,500 STX)

**Deliverable:** Working `Dusk.Stacks` node discovery backend.

- Iroh DHT namespace for Stacks nodes (`stacks/node/1` ALPN).
- `dusk stacks peers` CLI: discover, list, and ping Stacks nodes.
- Node identity: each node gets a stable Iroh peer ID derived from its Stacks `stx.address`.
- Integration with `stacks-node` config: auto-generate `p2p.bootnodes` from DHT peers.
- Tests: mock Iroh DHT, contract tests for discovery protocol.

**Verification:** Published v0.2.0 with docs and a demo showing two Stacks nodes discovering each other via Iroh without manual config.

### Milestone 2: FLAME Overlay for Stacks Off-Chain Services (Weeks 4–6, $1,500 STX)

**Deliverable:** FLAME backend for distributed Stacks indexers and relay monitors.

- `Dusk.FLAME.Backend` with Stacks-specific overlay config.
- Auto-discovery of FLAME workers via Iroh/Zenoh.
- Example: distributed Stacks block indexer that shards by burnchain block range.
- Example: sBTC relay health monitor that aggregates status from multiple relays.
- Integration with Crucible for provisioning workers across clouds.

**Verification:** Published v0.3.0 with a tutorial: "Running a Distributed Stacks Indexer with Dusk + Crucible".

### Milestone 3: sBTC Relay Pub/Sub + Production Packaging (Weeks 7–8, $1,500 STX)

**Deliverable:** Zenoh-based relay coordination and Burrito binary packaging.

- Zenoh pub/sub for sBTC relay state (`stacks/sbtc/relay/**`).
- Relay status aggregation and conflict detection.
- Burrito single-binary build for standalone CLI.
- Performance benchmarks: discovery latency, message throughput, failover time.
- Security review of peer identity and message authentication.

**Verification:** Published v0.4.0, demo at Stacks community event, and open issues for relay operator feedback.

---

## 6. Budget

| Item | Amount (STX) | Notes |
|------|-------------|-------|
| Development (3 milestones) | 3,600 | 8 weeks at ~450 STX/week |
| Cloud infrastructure for testing | 400 | Hetzner/DO nodes for live P2P tests |
| Documentation & demo production | 300 | Tutorials, screencasts |
| Buffer | 200 | Contingency |
| **Total** | **4,500** | Lower due to existing Dusk codebase |

**Disbursement:** 50% at Milestone 1 (Week 3), 50% at Milestone 3 (Week 8).

---

## 7. Team

**Niranjan Aryan** — solo builder, [@niranjanaryan](https://github.com/niranjanaryan).

- **Relevant experience:** Maintains Dusk (Zenoh + Iroh cluster), IngotCluster (Iroh+Zenoh), Crucible (multi-cloud provisioner), Gale (HTTP/3), and Orian (S3/S5 transfer). All published on Hex.pm with CI, docs, and community funding.
- **GitHub:** [github.com/niranjanaryan](https://github.com/niranjanaryan)
- **Stacks engagement:** First application. Building cluster infrastructure that makes Stacks node and relay networking resilient and distributed.

---

## 8. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Iroh/Zenoh protocol changes | Low | Medium | Pin to stable releases; abstract protocol layer |
| Stacks node config incompatibility | Medium | Medium | Support `stacks-node` v2.x+; document version pinning |
| NAT traversal issues for P2P | Medium | Medium | Use Iroh's hole-punching; fallback to Zenoh brokered mode |
| Scope creep (too many Stacks features) | Medium | Medium | Milestone 1 is discovery only; Milestone 2 adds FLAME; Milestone 3 adds relay |
| Solo builder bandwidth | Low | Low | 8 weeks, focused scope; existing Dusk codebase reduces risk |

---

## 9. Ecosystem Commitment

- **Long-term maintenance:** Dusk is part of a maintained Elixir infrastructure toolkit. Stacks overlay will receive ongoing updates.
- **Community:** Open to Stacks ecosystem contributions; will label `good first issue` for Stacks-specific work.
- **Stacks alignment:** Driver will evolve with Stacks releases (Nakamoto, PoX-5, sBTC). No exit strategy.

---

## 10. Proof of Work

- **Dusk:** Published on Hex.pm, Zenoh + Iroh cluster with BLAKE3/S5/S3 storage, CI, docs.
- **IngotCluster:** Iroh+Zenoh cluster package with DHT and pub/sub.
- **Crucible:** Multi-cloud provisioner with 100+ provider catalog.
- **GitHub:** Active maintainer of 6+ open-source Elixir repos.

---

## 11. Application Answers (Form-Field Ready)

**Project name:** Dusk — Stacks Cluster

**Track:** Getting Started Grant

**Theme:** Distribution & Integrations

**Problem:** Stacks node and sBTC relay networking relies on static configs and centralized relays, creating single points of failure.

**Solution:** A cluster backend for Dusk that gives Stacks nodes and relays Iroh/Zenoh-based discovery, FLAME-compatible off-chain workers, and pub/sub relay coordination.

**What you will ship and by when:**
- Week 3: Iroh DHT-based Stacks node discovery
- Week 6: FLAME overlay for distributed Stacks indexers/monitors
- Week 8: Zenoh pub/sub for sBTC relay coordination

**How this helps Stacks:** Makes Stacks node and relay networking resilient, distributed, and fault-tolerant without centralized infrastructure.

**Budget:** $4,500 STX — development, testing, documentation.

**Team:** Solo builder with 6+ open-source Elixir projects, including Dusk (Zenoh + Iroh cluster), IngotCluster, and Crucible.
