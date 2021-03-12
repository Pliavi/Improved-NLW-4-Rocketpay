defmodule Rocketpay.Account.Operations do
  alias Rocketpay.Account.Operations.UpdateBalance
  alias Rocketpay.Repo
  alias Ecto.Multi

  def withdraw(account, value) do
    account
    |> UpdateBalance.call(value, :withdraw)
  end

  def deposit(account, value) do
    account
    |> UpdateBalance.call(value, :deposit)
  end

  def transfer(from_account, to_account, value) do
    multi =
      Multi.new()
      |> Multi.run(:withdraw, fn _, _ -> withdraw(from_account, value) end)
      |> Multi.run(:deposit, fn _, _ -> deposit(to_account, value) end)

    case Repo.transaction(multi) do
      {:ok, %{withdraw: from, deposit: to}} ->
        {:ok, %{from: from, to: to, value: value}}

      {:error, _, reason, _} ->
        {:error, reason}
    end
  end
end
