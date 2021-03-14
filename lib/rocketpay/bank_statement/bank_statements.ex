defmodule Rocketpay.BankStatements do
  alias Rocketpay.Repo
  alias Rocketpay.BankStatement

  def create(user, value, type, reason \\ "") do
    bank_statement =
      BankStatement.changeset(
        %BankStatement{},
        %{
          user: user,
          value: value,
          type: type,
          reason: reason
        }
      )

    Repo.insert!(bank_statement)
  end
end
