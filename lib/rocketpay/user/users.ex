defmodule Rocketpay.Users do
  alias Ecto.{Multi, Changeset}
  alias Rocketpay.{Repo, User, Accounts}

  @spec create(map()) :: {:ok, User} | {:error, Changeset}
  def create(params) do
    multi =
      Multi.new()
      |> Multi.insert(:user, User.changeset(%User{}, params))
      |> Multi.run(:account, fn _, %{user: user} ->
        Accounts.create(user)
      end)
      |> Multi.run(:user_preloaded_account, fn repo, %{user: user} ->
        {:ok, repo.preload(user, :account)}
      end)

    case Repo.transaction(multi) do
      {:ok, %{user_preloaded_account: user}} -> {:ok, user}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  def update(user, params) do
    Repo.update(User.changeset(user, params))
  end

  def delete(user) do
    # TODO: check if there is no money in the account before delete
    Repo.delete(user)
  end
end
