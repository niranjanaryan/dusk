defmodule Dusk.FLAME.Backend do
  @moduledoc """
  Phoenix **FLAME** backend with Zenoh and/or Iroh overlay.

      config :flame, :backend, {Dusk.FLAME.Backend,
        overlay: :both,
        connect: "tcp/127.0.0.1:7447",
        key: "dusk/flame/runners"
      }
  """

  def init(opts) when is_list(opts) do
    overlay = Keyword.get(opts, :overlay, :zenoh)
    _ = start_overlay(overlay, opts)

    {:ok,
     %{
       overlay: overlay,
       opts: opts,
       runner: nil,
       node: Node.self()
     }}
  end

  def remote_boot(state) do
    parent = self()

    {:ok, pid} =
      Task.start_link(fn ->
        Process.flag(:trap_exit, true)

        receive do
          {:boot, caller} ->
            send(caller, {:booted, self(), Node.self()})
            loop(parent)
        end
      end)

    send(pid, {:boot, self()})

    receive do
      {:booted, runner, node} ->
        advertise(state, node, runner)
        {:ok, runner, %{state | runner: runner, node: node}}
    after
      5_000 -> {:error, :boot_timeout}
    end
  end

  def remote_spawn_monitor(%{runner: runner} = _state, func)
      when is_pid(runner) and is_function(func, 0) do
    req = make_ref()
    send(runner, {:spawn, self(), req, func})

    receive do
      {:spawned, ^req, pid} ->
        {:ok, {pid, Process.monitor(pid)}}
    after
      5_000 -> {:error, :spawn_timeout}
    end
  end

  def remote_spawn_monitor(state, func) when is_function(func, 0) do
    with {:ok, _term, state2} <- remote_boot(state) do
      remote_spawn_monitor(state2, func)
    end
  end

  def system_shutdown, do: :ok
  def handle_info(_msg, state), do: {:noreply, state}

  defp loop(parent) do
    receive do
      {:spawn, from, ref, func} ->
        {pid, _} = spawn_monitor(func)
        send(from, {:spawned, ref, pid})
        loop(parent)

      {:EXIT, ^parent, reason} ->
        exit(reason)

      _ ->
        loop(parent)
    end
  end

  defp start_overlay(:iroh, opts), do: start_iroh(opts)
  defp start_overlay(:zenoh, opts), do: start_zenoh(opts)
  defp start_overlay(:both, opts) do
    start_iroh(opts)
    start_zenoh(opts)
  end

  defp start_overlay(_, opts), do: start_overlay(:zenoh, opts)

  defp start_iroh(opts) do
    unless Process.whereis(Dusk.Iroh) do
      Dusk.Iroh.start_link(alpns: Keyword.get(opts, :alpns, ["dusk/flame"]))
    end
  rescue
    _ -> :ok
  end

  defp start_zenoh(opts) do
    unless Process.whereis(Dusk.Zenoh) do
      Dusk.Zenoh.start_link(
        connect: Keyword.get(opts, :connect, "tcp/127.0.0.1:7447"),
        key: Keyword.get(opts, :key, "dusk/flame/runners"),
        live: Keyword.get(opts, :live, false)
      )
    end
  rescue
    _ -> :ok
  end

  defp advertise(state, node, runner) do
    if function_exported?(Dusk.Zenoh, :put, 2) and Process.whereis(Dusk.Zenoh) do
      key = Keyword.get(state.opts, :key, "dusk/flame/runners")
      Dusk.Zenoh.put(key, "#{node} #{inspect(runner)}")
    else
      :ok
    end
  rescue
    _ -> :ok
  end
end
