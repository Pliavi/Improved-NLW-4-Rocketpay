defmodule Rocketpay.Repo.Migrations.CreateBankStatementTable do
  use Ecto.Migration

  def change do
    create table :bank_statement do
      add :value, :decimal
      add :account_id, references(:accounts, type: :binary_id)
      # TODO: Create a operation table
      add :operation, :string
      # TODO: Create a suboperation table
      add :sub_operation, :string
      add :reason, :string

      timestamps(updated_at: false, type: :utc_datetime_usec)
    end
  end
end
