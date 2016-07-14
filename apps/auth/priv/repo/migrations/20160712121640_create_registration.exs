defmodule Auth.Repo.Migrations.CreateRegistration do
  use Ecto.Migration

  def change do
    create table(:registrations) do
      add :country_code, :string
      add :digits, :string
      add :region, :string
      add :device_id, :string

      timestamps()
    end

    create unique_index(:registrations, [:country_code, :number, :uuid])
  end
end
