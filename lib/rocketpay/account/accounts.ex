defmodule Rocketpay.Accounts do
  alias Rocketpay.{Account, Repo}

  def create(user) do
    %Account{}
    |> Account.changeset(%{user_id: user.id, balance: "0.00"})
    |> Repo.insert()
  end

  def block(%{id: id}), do: set_block_date(id, :block)
  def unblock(%{id: id}), do: set_block_date(id, :unblock)

  defp set_block_date(id, :block), do: do_set_block_date(id, NaiveDateTime.utc_now())
  defp set_block_date(id, :unblock), do: do_set_block_date(id, nil)

  defp do_set_block_date(id, blocked_at) do
    Repo.get(Account, id)
    |> Account.changeset(%{blocked_at: blocked_at})
    |> Repo.update()
  end
end
