defmodule RocketpayWeb.OperationController do
  use RocketpayWeb, :controller

  alias Rocketpay.Account
  alias Rocketpay.Repo
  alias Rocketpay.Account.Operations

  action_fallback Rocketpay.FallbackController

  def deposit(conn, %{"id" => id, "value" => value}) do
    account = Repo.get!(Account, id)

    with {:ok, %Account{} = account} <- Operations.deposit(account, value) do
      render(conn, "update.json", account: account)
    end
  end

  def withdraw(conn, %{"id" => id, "value" => value}) do
    account = Repo.get!(Account, id)

    with {:ok, %Account{} = account} <- Operations.withdraw(account, value) do
      render(conn, "update.json", account: account)
    end
  end

  def transfer(conn, %{"from_id" => from_id, "to_id" => to_id, "value" => value}) do
    from_account = Repo.get!(Account, from_id)
    to_account = Repo.get!(Account, to_id)

    with {:ok, transfer} <- Operations.transfer(from_account, to_account, value) do
      render(conn, "transfer.json", transfer: transfer)
    end
  end
end
