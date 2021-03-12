defmodule RocketpayWeb.UserController do
  use RocketpayWeb, :controller

  alias Rocketpay.Users
  alias Rocketpay.Repo

  action_fallback Rocketpay.FallbackController

  def create(conn, params) do
    with {:ok, user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "params" => params}) do
    user = Repo.get!(Account, id)

    with {:ok, updated_user} <- Users.update(user, params) do
      render(conn, "update.json", user: updated_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(Account, id)

    with {:ok, deleted_user} <- Users.delete(user) do
      render(conn, "delete.json", user: deleted_user)
    end
  end
end
