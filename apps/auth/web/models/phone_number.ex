defmodule Auth.PhoneNumber do
  use Auth.Web, :model

  schema "phone_numbers" do
    field :country_code, :string
    field :digits, :string
    field :identifier, :string
    field :region, :string
    field :label, :string
    belongs_to :account, Auth.Account
    belongs_to :contact, Auth.Contact

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:country_code, :digits, :identifier, :region, :label, :account_id, :contact_id])
    |> validate_required([:country_code, :digits])
    |> validate_phone_number
    |> unique_constraint(:number, name: :phone_numbers_country_code_digits_index)
  end

  def validate_phone_number(changeset) do
    if changeset.valid? do
      changeset
      |> validate_length(:region, min: 2, max: 3)
      |> validate_country_code_and_number
    else
      changeset
    end
  end

  defp validate_country_code_and_number(changeset) do
    with \
      %Ecto.Changeset{
        valid?: true,
        changes: %{
          country_code: country_code,
          digits: digits,
          region: region
        }
      } <- changeset,
      {:ok, phone_number} <- ExPhoneNumber.parse("#{country_code}#{digits}", region),
      true <- ExPhoneNumber.is_valid_number?(phone_number)
    do
      changeset
    else
      %Ecto.Changeset{valid?: false} -> changeset
      _ -> add_error(changeset, :number, "invalid phone number")
    end
  end

end
