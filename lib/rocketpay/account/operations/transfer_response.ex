defmodule Rocketpay.Account.Operations.TransferResponse do
  alias Rocketpay.Account

  defstruct from_account: %Account{}, to_account: %Account{}
end
