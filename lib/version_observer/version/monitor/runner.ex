defmodule VersionObserver.Version.Monitor.Runner do
  alias VersionObserver.Version.Repo

  def run do
    case GenServer.multi_call(Repo, :get) do
      {nodes, []} ->
        do_check(nodes)

      {_, _invalid_nodes} ->
        {:error, :invalid_nodes}
    end
  end

  defp do_check(nodes) do
    nodes
    |> Keyword.values()
    |> Enum.uniq()
    |> case do
      [{:ok, version}] ->
        {:ok, version}

      _ ->
        {:error, :out_of_sync}
    end
  end
end
