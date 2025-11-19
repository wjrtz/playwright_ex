defmodule PlaywrightEx.Supervisor do
  @moduledoc """
  Playwright connection supervision tree.
  """

  use Supervisor

  def start_link(opts \\ []) do
    opts =
      opts
      |> Keyword.validate!([:timeout, js_logger: nil, runner: "npx", assets_dir: "assets"])
      |> Keyword.update!(:runner, &(System.find_executable(&1) || raise("Could not find runner #{&1}")))

    Supervisor.start_link(__MODULE__, Map.new(opts), name: __MODULE__)
  end

  @impl true
  def init(%{timeout: timeout, runner: runner, assets_dir: assets_dir, js_logger: js_logger}) do
    children = [
      {PlaywrightEx.PortServer, runner: runner, assets_dir: assets_dir},
      {PlaywrightEx.Connection, [[timeout: timeout, js_logger: js_logger]]}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
