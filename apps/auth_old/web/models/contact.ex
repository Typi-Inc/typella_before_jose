defmodule Auth.Contact do
  use Auth.Web, :model

  schema "contacts" do
    field :family_name, :string
    field :given_name, :string
    field :identifier, :string
    field :thumbnail_image_data, :string
    field :note, :string
    field :organization_name, :string
    has_one :birthday, Auth.Birthday
    has_many :email_addresses, Auth.EmailAddress
    has_many :phone_numbers, Auth.PhoneNumber
    has_many :postal_addresses, Auth.PhoneAddress
    belongs_to :account, Auth.Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:family_name, :given_name, :identifier, :thumbnail_image_data, :note, :organization_name])
    |> validate_required([:family_name, :given_name, :identifier, :thumbnail_image_data, :note, :organization_name])
  end
end
