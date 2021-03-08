defmodule Rocketpay.Users do
  alias Ecto.Multi
  alias Rocketpay.{Repo, User, Accounts}

  def create(params) do
    multi =
      Multi.new()
      |> Multi.insert(:user, User.changeset(params))
      |> Multi.run(:account, fn _, %{user: user} ->
        Accounts.create(user)
      end)
      |> Multi.run(:user_preloaded_account, fn repo, %{create_user: user} ->
        {:ok, repo.preload(user, :account)}
      end)

    case Repo.transaction(multi) do
      {:ok, %{user_preloaded_account: user}} -> {:ok, user}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  def update(user, params) do
    Repo.update(:user, User.changeset(user, params))
  end

  def delete(user) do
    # TODO: check if there is no money in the account before delete
    Repo.delete(user)
  end
end
