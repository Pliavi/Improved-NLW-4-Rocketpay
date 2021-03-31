defmodule Rocketpay.BankStatement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rocketpay.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_attrs ~w(value account_id operation)a
  @optional_attrs ~w(reason sub_operation)a

  schema "bank_statement" do
    field :value, :decimal
    field :operation, :string, virtual: true
    field :sub_operation, :string, virtual: true
    field :reason, :string

    belongs_to :account, Account

    timestamps(updated_at: false, type: :utc_datetime_usec)
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
  end
end
