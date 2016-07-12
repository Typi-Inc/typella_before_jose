defmodule Auth.Repo.Migrations.CreateBirthday do
  use Ecto.Migration

  def change do
    create table(:birthdays) do
      add :day, :integer, null: false
      add :month, :integer, null: false
      add :year, :integer
      add :contact_id, references(:contacts, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end
    create index(:birthdays, [:contact_id])
    create index(:birthdays, [:account_id])
    create unique_index(:birthdays, [:day, :month, :year])
  end
end
