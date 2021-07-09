defmodule VersionObserver.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: BackgroundJob.ClusterSupervisor]]},

      # Start the Telemetry supervisor
      VersionObserverWeb.Telemetry,

      # Start the PubSub system
      {Phoenix.PubSub, name: VersionObserver.PubSub},

      # Start the Version Repo
      VersionObserver.Version.Repo,

      # Start horde modules
      VersionObserver.HordeRegistry,
      VersionObserver.HordeSupervisor,
      VersionObserver.NodeObserver,

      # Version monitoring
      VersionObserver.Version.Monitor.Starter,

      # Start the Endpoint (http/https)
      VersionObserverWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: VersionObserver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    VersionObserverWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp topologies do
    [
      background_job: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
  end
end
