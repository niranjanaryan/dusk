# Elixir Forum Announcement — Dusk 0.1.0

Post this to [Elixir Forum](https://elixirforum.com/) under **Announcements** or **Libraries and Tools**.

---

**Title:** `[ANN] Dusk 0.1.0 — Zenoh + Iroh cluster for Elixir, BLAKE3/S5/S3 storage, HTTP/3`

**Body:**

Hi everyone,

I’m happy to announce the first public release of **Dusk** — a Zenoh + Iroh cluster library for Elixir with BLAKE3 hashing, S3/S5 storage, and a CLI.

Dusk is part of a small suite of packages for distributed Elixir:

```
gale        — Phoenix HTTP/3
ingot_cluster — Iroh + Zenoh cluster / libcluster
dusk        — Zenoh-first cluster
orian       — BLAKE3 / S3 / S5 storage
zeiroh      — Phoenix FLAME overlay
crucible    — boot the machine (local, docker, Fly/K8s/EC2)
```

**Why Dusk?**
- **Cluster**: plug-and-play Zenoh or Iroh discovery for `libcluster`.
- **Storage**: `:memory`, `:s3`, `:s5` — defers to [Orian](https://github.com/niranjanaryan/orian) when loaded.
- **Hashing**: Zig dirty-CPU NIF for BLAKE3 and XXH3.
- **CLI**: `mix dusk.install` drops a Burrito single binary (or escript). Example:
  ```bash
  dusk match "a/**" a/b
  dusk hash ./file --algo blake3
  dusk put ./file
  ```
- **Phoenix FLAME**: `Dusk.FLAME.Backend` overlay for local spawn loops.

**Install**
```elixir
defp deps do
  [
    {:dusk, "~> 0.1"},
    {:zenohex, "~> 0.10"}
  ]
end
```

**Docs & Source**
- [Hex.pm](https://hex.pm/packages/dusk)
- [Hexdocs](https://hexdocs.pm/dusk)
- [GitHub](https://github.com/niranjanaryan/dusk)

**Sponsor / Funding**
If this is useful to you, I would appreciate GitHub Sponsors to keep the NIFs and HTTP/3 storage paths maintained:
- [github.com/sponsors/niranjanaryan](https://github.com/sponsors/niranjanaryan)

Feedback, issues, and PRs welcome. Looking forward to hearing how people use it.

— Niranjan

---

## Posting Checklist

- [ ] Create account/login at [elixirforum.com](https://elixirforum.com/)
- [ ] Choose category: **Libraries and Tools** or **Announcements**
- [ ] Copy the body above (adjust if forum markdown differs)
- [ ] Attach screenshots if helpful (CLI output, benchmark table)
- [ ] Pin a self-reply with FAQ / known limits (FLAME local-only, OTP 27+)

## Follow-up Engagement Plan

1. **Day 1** — Post announcement, pin FAQ reply.
2. **Day 2–3** — Answer questions, share benchmark gist if requested.
3. **Week 1** — Update README with any forum-discovered issues, bump patch if needed.
4. **Week 2** — Cross-post links to Twitter/X, Mastodon, and any related Zenoh/Iroh channels.

## hex.pm Notes

- Package name: `dusk`
- Current version: `0.1.0`
- Docs are published automatically via CI.
- Ensure `FUNDING.md` is included in `files:` list in `mix.exs` (already present).
- Sponsor link already wired in `package: links:`.
