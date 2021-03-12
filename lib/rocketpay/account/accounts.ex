defmodule Rocketpay.Accounts do
  alias Rocketpay.{Account, Repo}

  def create(user) do
    %Account{}
    |> Account.changeset(%{user_id: user.id, balance: "0.00"})
    |> Repo.insert()
  end

  def set_block_state(id, :block), do: set_block_date(id, NaiveDateTime.utc_now())
  def set_block_state(id, :unblock), do: set_block_date(id, nil)

  defp set_block_date(id, blocked_at) do
    Repo.get(Account, id)
    |> Account.changeset(%{blocked_at: blocked_at})
    |> Repo.update()
  end
end
