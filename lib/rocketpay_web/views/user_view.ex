defmodule RocketpayWeb.UserView do
  alias Rocketpay.{User, Account}

  def render("create.json", %{
        user: %User{
          id: id,
          name: name,
          username: username,
          account: %Account{} = account
        }
      }) do
    %{
      message: "User created",
      user: %{
        id: id,
        name: name,
        username: username,
        account: %{
          id: account.id
        }
      }
    }
  end
end
