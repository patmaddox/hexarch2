module Hexarch2
  class App
    def initialize(storage)
      @storage = storage
    end

    def create_account(account_id, balance)
      @storage[account_id] = Account.new account_id, balance
    end

    def transaction_log(account_id)
      @storage[account_id].transaction_log
    end

    def withdraw(account_id, amount)
      @storage[account_id].withdraw amount
    end

    def deposit(account_id, amount)
      @storage[account_id].deposit amount
    end

    def balance_of(account_id)
      @storage[account_id].balance
    end
  end

  class Account
    attr_reader :balance, :transaction_log

    def initialize(id, balance)
      @id = id
      @balance = 0
      @transaction_log = []
      deposit balance
    end

    def withdraw(amount)
      @balance -= amount
      @transaction_log << [:debit, amount, @balance]
    end

    def deposit(amount)
      @balance += amount
      @transaction_log << [:credit, amount, @balance]
    end
  end
end
