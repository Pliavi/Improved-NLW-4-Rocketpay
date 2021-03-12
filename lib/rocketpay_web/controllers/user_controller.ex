defmodule RocketpayWeb.UserController do
  use RocketpayWeb, :controller

  alias Rocketpay.Users

  action_fallback Rocketpay.FallbackController

  def create(conn, params) do
    with {:ok, user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
