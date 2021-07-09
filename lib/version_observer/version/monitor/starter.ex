defmodule VersionObserver.Version.Monitor.Starter do
  require Logger

  alias VersionObserver.{
    HordeRegistry,
    HordeSupervisor,
    Version.Monitor
  }

  def start_link(opts) do
    name =
      opts
      |> Keyword.get(:name, Monitor)
      |> via_tuple()

    opts = Keyword.put(opts, :name, name)

    child_spec = %{
      id: Monitor,
      start: {Monitor, :start_link, [opts]}
    }

    HordeSupervisor.start_child(child_spec)

    :ignore
  end

  defp via_tuple(name) do
    {:via, Horde.Registry, {HordeRegistry, name}}
  end
end
