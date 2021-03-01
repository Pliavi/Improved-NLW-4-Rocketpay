defmodule Rocketpay.Account.Withdraw do
  alias Rocketpay.Account.Operation

  def call(params), do: Operation.call(params, :withdraw)
end
