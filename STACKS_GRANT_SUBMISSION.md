# Dusk Stacks Grant — Submission Checklist

**Portal:** https://portal.stacksendowment.co/apply/cycle-3  
**Deadline:** September 23, 2026  
**Track:** Getting Started Grant  
**Theme:** Distribution & Integrations

---

## Form Fields

### Project Name
```
Dusk — Stacks Cluster Overlay
```

### Track
```
Getting Started Grant
```

### Theme
```
Distribution & Integrations
```

### Problem Statement
```
Stacks node and sBTC relay networking relies on static configs and centralized relays. Node operators manually configure peers, and relay coordination depends on centralized message brokers. There is no Elixir-native Zenoh/Iroh overlay designed for Stacks infrastructure that provides content-addressed storage and high-performance hashing.
```

### Solution
```
Dusk adds a Stacks-specific overlay backend that provides Zenoh brokered pub/sub for relay coordination, Iroh DHT for node discovery, BLAKE3/XXH3 content addressing for block/transaction artifacts, and S3/S5 storage for relay state. All from Elixir, composable with existing Stacks tooling.
```

### What You Will Ship
```
Milestone 1 (Week 3): Zenoh pub/sub for Stacks node heartbeat and relay state
Milestone 2 (Week 7): Iroh DHT-based peer discovery with content-addressed block artifacts
Milestone 3 (Week 10): S3/S5 storage backend for relay logs + Burrito binary packaging
```

### How This Helps Stacks
```
Makes Stacks node and relay networking resilient and distributed without centralized infrastructure. Enables geo-redundant sBTC relay networks, content-addressed block storage, and high-throughput pub/sub for relay coordination.
```

### Budget
```
$6,000 STX — development (5,000 STX), cloud infrastructure for testing (500 STX), security review (250 STX), documentation (150 STX), buffer (100 STX)
```

### Team
```
Solo builder with 6+ open-source Elixir projects, including Dusk (Zenoh + Iroh cluster, BLAKE3/S5/S3 storage), IngotCluster (Iroh+Zenoh cluster), Zeiroh (FLAME overlay), Gale (HTTP/3), and Orian (S3/S5 transfer). All MIT-licensed with CI and docs.
```

---

## Links

- GitHub: https://github.com/niranjanaryan/dusk
- Hex.pm: https://hex.pm/packages/dusk
- Proposal: https://github.com/niranjanaryan/dusk/blob/main/STACKS_GRANT.md

---

## Milestones

### Milestone 1
- **Title:** Zenoh Pub/Sub for Stacks Relay Coordination
- **Amount:** $2,000 STX
- **Duration:** Weeks 1–3
- **Deliverables:** Zenoh key namespace for Stacks nodes, CLI: `dusk stacks peers`, relay heartbeat via `Dusk.Zenoh`

### Milestone 2
- **Title:** Iroh DHT + Content-Addressed Block Storage
- **Amount:** $2,000 STX
- **Duration:** Weeks 4–7
- **Deliverables:** Iroh DHT for peer discovery, BLAKE3 CID for block artifacts, `Dusk.Storage` backend for relay logs

### Milestone 3
- **Title:** Production Packaging + Benchmarks
- **Amount:** $2,000 STX
- **Duration:** Weeks 8–10
- **Deliverables:** Burrito binary, benchmarks against Stacks API patterns, documentation

---

## Disbursement
```
50% at Milestone 1 (Week 3)
50% at Milestone 3 (Week 10)
```
