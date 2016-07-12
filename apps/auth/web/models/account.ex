defmodule Auth.Account do
  use Auth.Web, :model

  schema "accounts" do
    has_one :birthday, Auth.Birthday
    has_many :contacts, Auth.Contact
    has_many :devices, Auth.Device
    has_many :email_addresses, Auth.EmailAddress
    has_many :phone_numbers, Auth.PhoneNumber
    has_many :postal_addresses, Auth.PhoneAddress

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
