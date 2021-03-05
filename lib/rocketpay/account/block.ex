defmodule Rocketpay.Account.Block do
  alias Rocketpay.Account
  alias Rocketpay.Repo

  def call(id) do
    Repo.get(Account, id)
    |> Account.changeset(%{blocked_at: NaiveDateTime.utc_now()})
    |> Repo.update()
  end
end
