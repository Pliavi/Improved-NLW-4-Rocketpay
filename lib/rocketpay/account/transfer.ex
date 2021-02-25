defmodule Rocketpay.Account.Transfer do
  alias Ecto.Multi
  alias Rocketpay.Repo
  alias Rocketpay.Account.Operation

  def call(%{"from" => from_id, "to" => to_id, "value" => value}) do
    withdraw_params = build_params(from_id, value)
    deposit_params = build_params(to_id, value)

    Multi.new()
    |> Multi.run(:withdraw, fn _repo, _changes -> Operation.call(withdraw_params, :withdraw) end)
    |> Multi.run(:deposit, fn _repo, _changes -> Operation.call(deposit_params, :deposit) end)
    |> run_transaction()
  end

  defp build_params(id, value), do: %{"id" => id, "value" => value}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:ok, result} -> result
      {:error, _operation, reason, _changes} -> {:error, reason}
    end
  end
end
