defmodule Auth.Device do
  use Auth.Web, :model

  schema "devices" do
    field :manufacturer, :string
    field :model, :string
    field :device_id, :string
    field :system_name, :string
    field :system_version, :string
    field :bundle_id, :string
    field :version, :string
    field :readable_version, :string
    field :device_name, :string
    field :user_agent, :string
    field :device_locale, :string
    field :device_country, :string
    field :instance_id, :string
    belongs_to :account, Auth.Account

    timestamps()
  end

  def validate_device_id(changeset) do
    changeset
    |> validate_format(:device_id, ~r/[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/)
  end
end
