defmodule Auth.PostalAddress do
  use Auth.Web, :model

  schema "postal_addresses" do
    field :identifier, :string
    field :city, :string
    field :country, :string
    field :label, :string
    field :postal_code, :string
    field :state, :string
    field :street, :string
    belongs_to :contact, Auth.Contact
    belongs_to :account, Auth.Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:identifier, :city, :country, :label, :postal_code, :state, :street])
    |> validate_required([:identifier, :city, :country, :label, :postal_code, :state, :street])
  end
end
