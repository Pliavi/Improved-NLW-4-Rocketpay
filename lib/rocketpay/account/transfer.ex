defmodule Rocketpay.Account.Transfer do
  alias Ecto.Multi
  alias Rocketpay.Repo
  alias Rocketpay.Account.Operations.TransferResponse
  alias Rocketpay.Account.{Deposit, Withdraw}

  def call(%{"from" => from_id, "to" => to_id, "value" => value}) do
    withdraw_params = build_params(from_id, value)
    deposit_params = build_params(to_id, value)

    Multi.new()
    |> Multi.run(:withdraw, fn _, _ -> Withdraw.call(withdraw_params) end)
    |> Multi.run(:deposit, fn _, _ -> Deposit.call(deposit_params) end)
    |> Repo.transaction()
    |> handle_result()
  end

  defp build_params(id, value), do: %{"id" => id, "value" => value}

  defp handle_result({:ok, %{withdraw: from_account, deposit: to_account}}) do
    {:ok, %TransferResponse{from_account: from_account, to_account: to_account}}
  end

  defp handle_result({:error, _operation, reason, _changes}) do
    {:error, reason}
  end
end
