defmodule Typi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :account_id, references(:accounts, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:users, [:account_id])
  end
end
