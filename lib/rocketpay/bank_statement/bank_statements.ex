defmodule Rocketpay.BankStatements do
  alias Rocketpay.Repo
  alias Rocketpay.BankStatement
  import Ecto.Query

  def create(attrs) do
    %BankStatement{}
    |> BankStatement.changeset(attrs)
    |> Repo.insert()
  end

  def get_all(account) do
    # XXX: It's using 90 days by default
    # TODO: Get based on start and end date
    ninety_days_from_now = DateTime.add(DateTime.utc_now(), -90 * 60 * 60 * 24)

    BankStatement
    |> where([bs], bs.account_id == ^account.id)
    |> where([bs], bs.inserted_at <= ^DateTime.utc_now())
    |> where([bs], bs.inserted_at >= ^ninety_days_from_now)
    # |> select([bs], bs.value)
    |> Repo.all()
  end
end
