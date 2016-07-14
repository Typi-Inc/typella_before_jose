defmodule Auth.Repo.Migrations.CreatePostalAddress do
  use Ecto.Migration

  def change do
    create table(:postal_addresses) do
      add :identifier, :string
      add :city, :string
      add :country, :string
      add :label, :string
      add :postal_code, :string
      add :state, :string
      add :street, :string
      add :contact_id, references(:contacts, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end
    
    create index(:postal_addresses, [:contact_id])
    create index(:postal_addresses, [:account_id])
    create unique_index(:postal_addresses, [:country, :postal_code, :street])
  end
end
