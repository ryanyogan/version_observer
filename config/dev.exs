use Mix.Config

config :version_observer, VersionObserverWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    npm: ["run", "watch", cd: Path.expand("../assets", __DIR__)]
  ]

config :version_observer, VersionObserverWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/version_observer_web/(live|views)/.*(ex)$",
      ~r"lib/version_observer_web/templates/.*(eex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
