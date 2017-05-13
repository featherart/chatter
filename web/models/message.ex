defmodule Chatter.Message do
  use Chatter.Web, :model

  schema "messages" do
    field :name, :string
    field :text, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :text])
    |> validate_required([:name, :text])
  end
end
