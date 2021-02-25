defmodule Rocketpay.User.Get do
  alias Rocketpay.{Repo, User}

  def get_user() do
    User
    |> Repo.all()
  end
end
