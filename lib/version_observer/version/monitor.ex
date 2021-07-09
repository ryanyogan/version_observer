defmodule VersionObserver.Version.Monitor do
  use GenServer

  alias __MODULE__.Runner
  alias Phoenix.PubSub
  alias VersionObserver.{NodeObserver, Version}

  @publish_topic "version_monitor"

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    subscribe_topic = Keyword.get(opts, :subscribe_topic, NodeObserver.topic())

    GenServer.start_link(__MODULE__, subscribe_topic, name: name)
  end

  @impl GenServer
  def init(subscribe_topic) do
    PubSub.subscribe(VersionObserver.PubSub, subscribe_topic)

    {:ok, %Version{}}
  end

  @impl GenServer
  def handle_info(:nodeup, state) do
    {:noreply, state, {:continue, :check}}
  end

  @impl GenServer
  def handle_info(:nodedown, state) do
    {:noreply, state, {:continue, :check}}
  end

  @impl GenServer
  def handle_continue(:check, state) do
    with {:ok, new_version} <- Runner.run(),
         true <- Version.incompatible?(new_version, state) do
      Process.sleep(1_000)

      PubSub.broadcast(
        VersionObserver.PubSub,
        @publish_topic,
        {:new_version, to_string(new_version)}
      )

      {:noreply, new_version}
    else
      false ->
        {:noreply, state}

      {:error, :invalid_nodes} ->
        Process.sleep(1_000)

        {:noreply, state, {:continue, :check}}

      {:error, :out_of_sync} ->
        {:noreply, state}
    end
  end
end
