defmodule Earlierthoughts.Repo do
  use Ecto.Repo,
    otp_app: :earlierthoughts,
    adapter: Ecto.Adapters.Postgres
end
