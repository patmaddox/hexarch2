module Hexarch2
  class App
    def initialize(storage)
      @storage = storage
    end

    def create_account(account_id, balance)
      @storage[account_id] = Account.new account_id, balance
    end

    def withdraw(account_id, amount)
      @storage[account_id].withdraw amount
    end
    def balance_of(account_id)
      @storage[account_id].balance
    end
  end

  class Account
    attr_reader :balance

    def initialize(id, balance)
      @id = id
      @balance = balance
    end

    def withdraw(amount)
      @balance -= amount
    end
  end
end
