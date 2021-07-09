defmodule VersionObserver.Version.Repo do
  use GenServer

  alias VersionObserver.Version

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)

    GenServer.start_link(__MODULE__, %{}, name: name)
  end

  def get(name \\ __MODULE__), do: GenServer.call(name, :get)

  @impl GenServer
  def init(_) do
    {:ok, version} =
      :version_observer
      |> Application.spec(:vsn)
      |> to_string()
      |> Version.from_string()

    {:ok, version}
  end

  @impl GenServer
  def handle_call(:get, _, version) do
    {:reply, {:ok, version}, version}
  end
end
