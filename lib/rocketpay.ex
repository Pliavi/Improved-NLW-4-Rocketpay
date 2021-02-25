alias Rocketpay.User.Create, as: UserCreate
alias Rocketpay.Account.{Deposit, Withdraw, Transfer}

defmodule Rocketpay do
  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate transfer(params), to: Transfer, as: :call
end
