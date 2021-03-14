defmodule Rocketpay.BankStatement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rocketpay.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_attrs ~w(value user_id type)a
  @optional_attrs ~w(reason)a

  schema "accounts" do
    field :value, :decimal
    field :type, :string
    field :reason, :string

    belongs_to :user, User

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
  end
end
