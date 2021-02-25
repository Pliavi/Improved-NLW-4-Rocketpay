defmodule Rocketpay.Account.Operation do
  require Decimal
  alias Rocketpay.{Account, Repo}
  alias Ecto.Changeset

  def call(%{"id" => id, "value" => value}, operation) do
    Repo.get(Account, id)
    |> update_balance(Decimal.cast(value), operation)
    |> update_account
  end

  defp update_balance(%Account{} = account, {:ok, value}, :deposit) do
    new_balance = %{balance: Decimal.add(account.balance, value)}

    Account.changeset(account, new_balance)
  end

  defp update_balance(%Account{} = account, {:ok, value}, :withdraw) do
    new_balance = %{balance: Decimal.sub(account.balance, value)}

    Account.changeset(account, new_balance)
  end

  defp update_balance(nil, _value, _operation), do: {:error, "Account not found!"}
  defp update_balance(_account, :error, _operation), do: {:error, "Invalid value!"}

  defp update_account(%Changeset{} = account), do: Repo.update(account)
  defp update_account({:error, _message} = error), do: error
end
