defmodule Rocketpay.Account.Deposit do
  alias Rocketpay.Account.Operation

  def call(params) do
    Operation.call(params, :deposit)
  end

end
