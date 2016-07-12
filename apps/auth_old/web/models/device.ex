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

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:manufacturer, :model, :device_id, :system_name, :system_version, :bundle_id, :version, :readable_version, :device_name, :user_agent, :device_locale, :device_country, :instance_id])
    |> validate_required([:manufacturer, :model, :device_id, :system_name, :system_version, :bundle_id, :version, :readable_version, :device_name, :user_agent, :device_locale, :device_country, :instance_id])
  end
end
