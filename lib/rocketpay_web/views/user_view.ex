defmodule RocketpayWeb.UserView do
  alias Rocketpay.User

  def render("create.json", %{user: %User{id: id, name: name, username: username}}) do
    %{
      message: "User created",
      user: %{
        id: id,
        name: name,
        username: username
      }
    }
  end
end
