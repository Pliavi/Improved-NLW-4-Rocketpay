defmodule Rocketpay.Repo.Migrations.CreateBankStatementTable do
  use Ecto.Migration

  def change do
    create table :bank_statement do
      add :value, :decimal
      add :user_id, references(:users, type: :binary_id)
      add :type, :string # TODO: Create a type table
      add :reason, :string

      timestamps(:updated_at: false, type: :utc_datetime_usec)
    end
  end
end
