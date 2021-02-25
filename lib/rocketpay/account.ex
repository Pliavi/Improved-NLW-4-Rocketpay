defmodule Rocketpay.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Rocketpay.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_attrs [:balance, :user_id]

  schema "accounts" do
    field :balance, :decimal
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %Account{}, attrs) do
    struct
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
