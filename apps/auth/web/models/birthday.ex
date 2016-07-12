defmodule Auth.Birthday do
  use Auth.Web, :model

  schema "birthdays" do
    field :day, :integer
    field :month, :integer
    field :year, :integer
    belongs_to :contact, Auth.Contact
    belongs_to :account, Auth.Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:day, :month, :year])
    |> validate_required([:day, :month, :year])
  end
end
