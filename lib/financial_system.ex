defmodule FinancialSystem do
  @moduledoc """
  Documentation for FinancialSystem.
  """
  require Account

  defmacro left >>> right do
    quote do
      case unquote(left) do
        { :ok, account_a, account_b, value } -> {:ok, account_a, account_b, value } |> unquote(right)
        { :error, error_message } = expr -> expr
      end
    end
  end

  @doc """
  Transfer a given value from one account to the other. In case of error, in the inner functions an exception will
  be thrown upward until the transfer caller.

  ## Parameters
    - transfer_account: Account struct that represnts the transferer account.
    - transfered_account: Account struct that represents the account that will receive the transfer.
    - transfered_value: The value to be transfered from the transfer_account to the transfered_account.
  """
  @spec transfer(%Account{},%Account{}, integer) :: { %Account{}, %Account{}}
  def transfer(%Account{} = transfer_account, %Account{} = transfered_account, transfered_value) do
    try do    
      { :ok, transfer_account, transfered_account, transfered_value }
      >>> transfer_valid
      >>> exchange
    catch
      error -> error
      throw error
    end
  end


  def transfer(%Account{} = transfer_account, transfered_accounts, transfered_value) do
    # Enum.map(transfered_accounts, fn x -> 
    #   case transfer(transfer_account, x, transfered_value / length(transfered_accounts)) do
    #     {:ok, transfer_account, transfered_account} <- {transfer_account, transfered_account},
    #     {:error, message} <-  
    # end)
    
    [head | tail] = transfered_accounts
    IO.puts "lol"
    if tail == [] do
      {:ok, transfer_account, transfered_account} = transfer(transfer_account, head, transfered_value)
      {transfer_account, [transfered_account]}
    else
      {account, list} = transfer(transfer_account, tail, transfered_value)
      IO.inspect list
      {:ok, accounts, transfered_account} = transfer(account, head, transfered_value)
      {accounts, List.insert_at(list, 0, transfered_account)}
    end
  end

  def exchange({:ok, %Account{} = transfer_account, %Account{} = transfered_account, transfered_value}) do
    transfered_account = %{ transfered_account | balance: transfered_account.balance + transfered_value }
    transfer_account = %{ transfer_account | balance: transfer_account.balance - transfered_value }

    {:ok, transfer_account, transfered_account}
  end

  @doc """
  Checks if a transfer between two accounts of a given value is valid. A transfer between accounts is considered
  valid when both use the same currency and the account that is going to transfer has positive balance.

  ## Parameters
    - transfer_acc: `Account` struct that is transfering the value.
    - transfered_acc: Account struct that will receive the transfer.
    - transfered_value: Value to be transfered from transfer_acc.
  """
  def transfer_valid({:ok, %Account{} = transfer_acc, %Account{} = transfered_acc, transfered_value }) do
    try do
      {:ok, transfer_acc, transfered_acc, transfered_value }
      >>> same_currency?        
      >>> has_positive_balance
    catch 
      error -> error
      throw error
    end
  end

  @doc """
  Checks if the passed account has positive balance. If it doesn't an
  exception is fired with the message "Transfer account balance is negative"
  """
  def has_positive_balance({:ok, %Account{} = transfer_acc, %Account{} = transfered_acc, transfered_value } ) do
    if transfer_acc.balance > 0 do
      { :ok, transfer_acc, transfered_acc, transfered_value }
    else
      {:error, "Transfer Account has negative balance."}
    end
  end

  @doc """
  Checks if accounts passed have the same currency
  """
  def same_currency?({:ok, %Account{} = transfer_acc, %Account{} = transfered_acc, transfered_value }) do
    if transfer_acc.currency == transfered_acc.currency do
      { :ok, transfer_acc, transfered_acc, transfered_value }
    else
      {:error, "Accounts have different currencies"}
    end
  end

end
