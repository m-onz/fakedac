
config :your_app, Fakedac.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  server: true
