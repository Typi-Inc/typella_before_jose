defmodule Auth.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :manufacturer, :string
      add :model, :string
      add :device_id, :string
      add :system_name, :string
      add :system_version, :string
      add :bundle_id, :string
      add :version, :string
      add :readable_version, :string
      add :device_name, :string
      add :user_agent, :string
      add :device_locale, :string
      add :device_country, :string
      add :instance_id, :string
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end
    create index(:devices, [:account_id])
    create unique_index(:devices, [:device_id])
  end
end
