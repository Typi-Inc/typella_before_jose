defmodule Auth.Repo.Migrations.CreateContact do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :family_name, :string
      add :given_name, :string
      add :identifier, :string
      add :thumbnail_image_data, :string
      add :note, :string
      add :organization_name, :string
      add :account_id, references(:accounts, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:contacts, [:account_id])
  end
end
