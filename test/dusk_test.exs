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
end
