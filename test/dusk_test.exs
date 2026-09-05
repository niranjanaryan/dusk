defmodule DuskTest do
  use ExUnit.Case, async: false

  setup do
    on_exit(fn ->
      for name <- [Dusk.Iroh, Dusk.Zenoh] do
        if pid = Process.whereis(name) do
          try do
            GenServer.stop(pid, :normal, 500)
          catch
            :exit, _ -> :ok
          end
        end
      end
    end)

    :ok
  end

  test "Zig NIF key_match and hash64" do
    assert Dusk.nif_loaded?()
    assert Dusk.key_match("dusk/cluster/**", "dusk/cluster/us/n1") == true
    assert Dusk.key_match("dusk/*/x", "dusk/a/x") == true
    assert Dusk.key_match("dusk/a", "dusk/b") == false
    assert is_integer(Dusk.hash64("hello"))
    assert byte_size(Dusk.blake3("hello")) == 32
    assert is_integer(Dusk.xxh3("hello"))
  end

  test "backends" do
    b = Dusk.backends()
    assert is_boolean(b.zenoh)
    assert is_boolean(b.iroh)
    assert is_boolean(b.zig_nif)
  end

  test "iroh + zenoh cluster" do
    {:ok, pid} =
      Dusk.start_link(
        name: Dusk.Cluster.Iron,
        iroh: [alpns: ["dusk/1"]],
        zenoh: [connect: "tcp/127.0.0.1:7447", live: false]
      )

    assert Process.alive?(pid)
    assert {:error, :backend_not_loaded} = Dusk.Iroh.endpoint()
    Supervisor.stop(pid)
  end

  test "memory storage" do
    {:ok, cid} = Dusk.Storage.put("dusk blob")
    assert {:ok, "dusk blob"} = Dusk.Storage.get(cid)
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

  test "libcluster Zenoh and Iroh strategies start" do
    {:ok, z} =
      Dusk.Strategy.Zenoh.start_link(
        topology: :dusk,
        config: [interval: 60_000, nodes: []]
      )

    {:ok, i} =
      Dusk.Strategy.Iroh.start_link(
        topology: :dusk_iroh,
        config: [interval: 60_000, nodes: []]
      )

    assert Process.alive?(z) and Process.alive?(i)
    GenServer.stop(z)
    GenServer.stop(i)
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
