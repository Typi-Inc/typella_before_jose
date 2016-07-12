defmodule Auth.PhoneNumber do
  use Auth.Web, :model

  schema "phone_numbers" do
    field :country_code, :string
    field :digits, :string
    field :identifier, :string
    field :region, :string
    field :label, :string
    belongs_to :contact, Auth.Contact
    belongs_to :account, Auth.Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:country_code, :digits, :identifier, :region, :label])
    |> validate_required([:country_code, :digits, :identifier, :region, :label])
  end
end
