defmodule Neoex.Repo do
  use Ecto.Repo,
    otp_app: :neoex,
    adapter: Ecto.Adapters.Postgres
end
