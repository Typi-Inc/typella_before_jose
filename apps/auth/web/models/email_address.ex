defmodule Auth.EmailAddress do
  use Auth.Web, :model

  schema "email_addresses" do
    field :identifier, :string
    field :label, :string
    field :value, :string
    belongs_to :contact, Auth.Contact
    belongs_to :account, Auth.Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:identifier, :label, :value])
    |> validate_required([:identifier, :label, :value])
  end
end
