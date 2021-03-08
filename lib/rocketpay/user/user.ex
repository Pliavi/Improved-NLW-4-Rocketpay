defmodule Rocketpay.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Ecto.Changeset
  alias Rocketpay.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_attrs [:name, :username, :email, :age, :password]

  schema "users" do
    field :name, :string
    field :username, :string
    field :email, :string
    field :age, :integer
    field :password, :string, virtual: true
    field :password_hash, :string
    has_one :account, Account

    timestamps()
  end

  def changeset(struct \\ %User{}, attrs) do
    struct
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
    |> validate_length(:password, min: 6)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, ~r/^[\w-\.]+@\w([\w-]+\.)*[\w-]{2,}$/)
    |> unique_constraint([:email])
    |> unique_constraint([:nickname])
    |> put_password_hash()
  end

  defp put_password_hash(changeset = %Changeset{valid?: true, changes: %{password: password}}) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
