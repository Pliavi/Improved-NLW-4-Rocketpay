defmodule Rocketpay.Account.Operations.UpdateBalance do
  require Decimal
  alias Rocketpay.{Account, Repo}
  alias Ecto.Changeset

  def call(account, value, operation) do
    account
    |> update_balance(Decimal.cast(value), operation)
    |> update_account()
  end

  defp update_balance(account, {:ok, value}, :deposit) do
    new_balance = %{balance: Decimal.add(account.balance, value)}

    Account.changeset(account, new_balance)
  end

  defp update_balance(%Account{blocked_at: nil} = account, {:ok, value}, :withdraw) do
    new_balance = %{balance: Decimal.sub(account.balance, value)}

    Account.changeset(account, new_balance)
  end

  defp update_balance(%Account{}, _, :withdraw) do
    {:error, "Account is blocked!"}
  end

  defp update_balance(nil, _, _) do
    {:error, "Account not found!"}
  end

  defp update_balance(_, :error, _) do
    {:error, "Invalid value!"}
  end

  defp update_account(%Changeset{} = account), do: Repo.update(account)
  defp update_account({:error, _} = error), do: error
end
