defmodule Rocketpay.Account.Operations do
  alias Rocketpay.Account.Operations.UpdateBalance

  def withdraw(account, value) do
    account
    |> MoneyOperation.call(value, :withdraw)
  end

  def deposit(account, value) do
    account
    |> MoneyOperation.call(value, :deposit)
  end

  def transfer(from_account, to_account, value) do
    multi =
      Multi.new()
      |> Multi.run(:withdraw, fn _, _ -> withdraw(from_account, value) end)
      |> Multi.run(:deposit, fn _, _ -> deposit(to_account, value) end)

    case Repo.transaction(multi) do
      {:ok, %{withdraw: from, deposit: to}} ->
        {:ok, %{from: from, to: to}}

      {:error, _, reason, _} ->
        {:error, reason}
    end
  end
end
