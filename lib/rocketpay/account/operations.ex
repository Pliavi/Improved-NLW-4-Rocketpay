defmodule Rocketpay.Account.Operations do
  alias Rocketpay.Account.Operations.UpdateBalance
  alias Rocketpay.{BankStatements, Repo}
  alias Ecto.Multi

  # TODO: Use transaction(Multi) to update balance without creating statement
  def withdraw(account, value, additional_statement_attrs \\ %{}) do
    BankStatements.create(
      Map.merge(
        %{value: value, operation: "withdraw", account_id: account.id},
        additional_statement_attrs
      )
    )

    account
    |> UpdateBalance.call(value, :withdraw)
  end

  # TODO: Use transaction(Multi) to update balance without creating statement
  def deposit(account, value, additional_statement_attrs \\ %{}) do
    BankStatements.create(
      Map.merge(
        %{value: value, operation: "deposit", account_id: account.id},
        additional_statement_attrs
      )
    )

    account
    |> UpdateBalance.call(value, :deposit)
  end

  # TODO: Use transaction(Multi) to update balance without creating statement
  def transfer(from_account, to_account, value) do
    # função anônima
    do_operation = fn fun, account, value ->
      # função anônima pra "bypassar" os dados do Multi.run
      fn _, _ ->
        account = Repo.preload(account, :user)

        fun.(account, value, %{
          sub_operation: "transfer",
          reason: "Transfer: #{account.user.name}"
        })
      end
    end

    multi =
      Multi.new()
      |> Multi.run(:withdraw, do_operation.(&withdraw/3, from_account, value))
      |> Multi.run(:deposit, do_operation.(&deposit/3, to_account, value))

    case Repo.transaction(multi) do
      {:ok, %{withdraw: from, deposit: to}} ->
        {:ok, %{from: from, to: to, value: value}}

      {:error, _, reason, _} ->
        {:error, reason}
    end
  end
end
