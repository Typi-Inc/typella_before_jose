defmodule Auth.Registration do
  use Auth.Web, :model

  schema "registrations" do
    field :country_code, :string
    field :digits, :string
    field :region, :string
    field :device_id, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:country_code, :digits, :region, :device_id])
    |> validate_required([:country_code, :digits, :region, :device_id])
    |> Auth.PhoneNumber.validate_phone_number
    |> Auth.Device.validate_device_id
  end
end
