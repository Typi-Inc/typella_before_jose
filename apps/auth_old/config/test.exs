use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "typi_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
