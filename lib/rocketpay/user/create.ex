defmodule Rocketpay.User.Create do
  alias Ecto.Multi
  alias Rocketpay.Account.Create, as: CreateAccount
  alias Rocketpay.{Repo, User}

  defdelegate insert_account(user), to: CreateAccount, as: :call

  def call(params) do
    Multi.new()
    |> Multi.insert(:create_user, User.changeset(params))
    |> Multi.run(:create_account, &do_insert_account/2)
    |> Multi.run(:preload_data, &preload_data/2)
    |> run_transaction()
  end

  defp do_insert_account(_repo, %{create_user: user}), do: insert_account(user)

  defp preload_data(repo, %{create_user: user}), do: {:ok, repo.preload(user, :account)}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{preload_data: user}} -> {:ok, user}
    end
  end
end
