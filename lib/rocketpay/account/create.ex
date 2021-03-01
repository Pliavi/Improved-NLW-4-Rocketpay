defmodule Rocketpay.Account.Create do
  alias Rocketpay.{Account, Repo}

  def call(user) do
    %{user_id: user.id, balance: "0.00"}
    |> Account.changeset()
    |> Repo.insert()
  end
end
