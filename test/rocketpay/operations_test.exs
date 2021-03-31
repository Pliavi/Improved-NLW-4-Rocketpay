defmodule Rocketpay.OperationsTest do
  use Rocketpay.DataCase, async: true
  alias Rocketpay.Users
  alias Rocketpay.Account
  alias Rocketpay.Account.Operations
  alias Rocketpay.BankStatements
  alias Rocketpay.BankStatement
  alias Rocketpay.Repo

  setup do
    non_unique_params = %{
      name: "Any Name",
      password: "123456",
      age: 25
    }

    {:ok, deposit_user} =
      Users.create(
        Map.merge(non_unique_params, %{
          username: "pliavi",
          email: "pliavi@pliavi.com"
        })
      )

    {:ok, withdraw_user} =
      Users.create(
        Map.merge(non_unique_params, %{
          username: "nubi",
          email: "nubi@nubi.com"
        })
      )

    {:ok, deposit_account: deposit_user.account, withdraw_account: withdraw_user.account}
  end

  describe "withdraw and deposit" do
    test "successfully deposit then withdraw", context do
      {:ok, account} = Operations.deposit(context[:deposit_account], "50.00")
      {:ok, account} = Operations.withdraw(account, "25.00")

      assert Decimal.equal?(account.balance, 25)
    end

    test "fail to withdraw when there is no funds", context do
      {:ok, account} = Operations.deposit(context[:deposit_account], "50.00")
      {:error, changeset} = Operations.withdraw(account, "75.00")

      assert "value must be positive" in errors_on(changeset).balance
    end

    test "fail to deposit using a invalid value", context do
      {:error, error} = Operations.deposit(context[:deposit_account], "a50.00")

      assert error == "invalid value"
    end
  end

  describe "transfer" do
    test "successfully make a transfer", context do
      deposit_account = context[:deposit_account]

      {:ok, withdraw_account} =
        Operations.deposit(
          context[:deposit_account],
          "50.00"
        )

      {:ok, %{from: from_account, to: to_account}} =
        Operations.transfer(
          withdraw_account,
          deposit_account,
          "25.00"
        )

      assert Decimal.equal?(from_account.balance, 25)
      assert Decimal.equal?(to_account.balance, 25)
    end
  end

  describe "bank statement" do
    test "check bank statement", context do
      account_id = context[:deposit_account].id

      Enum.each(5..1, fn x ->
        account = Repo.get(Account, account_id)
        {:ok, _} = Operations.deposit(account, Integer.to_string(x))
      end)

      account = Repo.get(Account, account_id)

      res =
        BankStatements.get_all(account)
        |> Enum.map(fn %{value: value} -> value end)

      assert res == 5..1 |> Enum.map(&Decimal.new/1)
    end
  end
end
