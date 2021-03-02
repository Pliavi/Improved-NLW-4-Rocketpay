defmodule RocketpayWeb.TransactionView do
  alias Rocketpay.Account
  alias Rocketpay.Account.Operations.TransferResponse

  def render("update.json", %{account: %Account{} = account}) do
    %{
      message: "Ballance changed successfully",
      account: %{
        id: account.id,
        balance: account.balance
      }
    }
  end

  def render("transfer.json", %{transfer: %TransferResponse{} = transfer}) do
    %{
      message: "Transfer done successfully",
      transfer: %{
        from_account: %{
          id: transfer.from_account.id,
          balance: transfer.from_account.balance
        },
        to_account: %{
          id: transfer.to_account.id,
          balance: transfer.to_account.balance
        }
      }
    }
  end
end
