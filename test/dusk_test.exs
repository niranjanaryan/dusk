defmodule DuskTest do
  use ExUnit.Case, async: false

  test "Zig NIF key_match and hash64" do
    assert Dusk.nif_loaded?()
    assert Dusk.key_match("dusk/cluster/**", "dusk/cluster/us/n1") == true
    assert Dusk.key_match("dusk/*/x", "dusk/a/x") == true
    assert Dusk.key_match("dusk/a", "dusk/b") == false
    assert is_integer(Dusk.hash64("hello"))
  end

  test "backends" do
    b = Dusk.backends()
    assert is_boolean(b.zenoh)
    assert is_boolean(b.zig_nif)
  end

  test "cluster stub without live zenohd" do
    {:ok, pid} =
      Dusk.start_link(
        name: Dusk.Cluster.Test,
        connect: "tcp/127.0.0.1:7447",
        live: false
      )

    assert Process.alive?(pid)
    assert {:error, :backend_not_loaded} = Dusk.Zenoh.put("dusk/x", "hi")
    Supervisor.stop(pid)
  end

  test "libcluster Zenoh strategy starts" do
    {:ok, pid} =
      Dusk.Strategy.Zenoh.start_link(
        topology: :dusk,
        config: [interval: 60_000, nodes: []]
      )

    assert Process.alive?(pid)
    GenServer.stop(pid)
  end

  test "FLAME backend boots and runs a function" do
    {:ok, state} = Dusk.FLAME.Backend.init(live: false)
    {:ok, _term, state} = Dusk.FLAME.Backend.remote_boot(state)
    parent = self()

    assert {:ok, {pid, ref}} =
             Dusk.FLAME.Backend.remote_spawn_monitor(state, fn ->
               send(parent, :dusk_ran)
               :ok
             end)

    assert is_pid(pid)
    assert is_reference(ref)
    assert_receive :dusk_ran, 1_000
  end
end
