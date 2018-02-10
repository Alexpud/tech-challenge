defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  test "User should be able to transfer money to another account" do
    try do
      account_a = %Account{}
      account_a = %{account_a | balance: 50}
      account_b = %Account{}
      {:ok, account_a, account_b} = FinancialSystem.transfer(account_a, account_b, 20)
      assert account_a.balance == 30
      assert account_b.balance == 20
      assert :ok
    catch
      x -> x
      assert :false
    end
  end

  test "User cannot transfer if not enough money available on the account" do
    try do
      account_a = %Account{}
      account_a = %{account_a | balance: -50}
      account_b = %Account{}
      {:error, message} = FinancialSystem.transfer(account_a, account_b, 20)
      assert message == "Transfer Account has negative balance."
    catch
      error -> error
      assert :false
    end
  end

  test "A transfer should be cancelled if an error occurs" do
    assert :false
  end

  test "A transfer can be splitted between 2 or more accounts" do
     try do
      account_a = %Account{}
      account_a = %{account_a | balance: 50}
      account_b = %Account{}
      account_c = %Account{}
      {transfer_account, [transfered_accounts]} = FinancialSystem.transfer(account_a, [account_b, account_c], 20)
    catch
      error -> error
      assert :false
    end
  end

  test "User should be able to exchange money between different currencies" do
    assert :false
  end

  test "Currencies should be in compliance with ISO 4217" do
    assert :false
  end
end
