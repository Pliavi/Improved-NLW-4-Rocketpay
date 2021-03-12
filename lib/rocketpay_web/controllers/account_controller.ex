defmodule RocketpayWeb.AccountController do
  use RocketpayWeb, :controller

  alias Rocketpay.{Account, Accounts}
  alias Rocketpay.Repo

  def set_block(conn, %{"id" => id, "block_state" => block}) do
    account = Repo.get!(Account, id)

    with {:ok, _} <- Accounts.set_block_state(account, String.to_atom(block)) do
      render(conn, "block.json", status: "blocked")
    end
  end
end
