defmodule EarlierThoughts.Lists.List do
  use Ecto.Schema

  embedded_schema do
    field(:uuid, :string)
  end
end
