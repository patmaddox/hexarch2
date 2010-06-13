module Hexarch2
  class App
    def initialize(event_storage, reporting_storage)
      @event_storage = event_storage
      @reporting_storage = reporting_storage
      @event_handlers = Hash.new {|hash, k| hash[k] = [] }
      @event_handlers[:account_created] << @event_storage
      @event_handlers[:account_created] << @reporting_storage
      @event_handlers[:amount_withdrawn] << @event_storage
      @event_handlers[:amount_withdrawn] << @reporting_storage
    end

    def create_account(account_id, balance)
      publish :account_created, account_id, balance
    end

    def withdraw(account_id, amount)
      account = fetch_account account_id
      account.withdraw amount
    end

    def fetch_account(account_id)
      account = Account.new(account_id, self)
      events = @event_storage.fetch_events account_id
      events.each {|e| account.replay(e) }
      account
    end

    def balance_of(account_id)
      @reporting_storage.balance_of account_id
    end

    def publish(event_name, *args)
      @event_handlers[event_name].each {|h| h.send(event_name, *args) }
    end
  end

  class Account
    def initialize(id, event_publisher)
      @id = id
      @event_publisher = event_publisher
    end

    def withdraw(amount)
      do_withdraw amount
      @event_publisher.publish :amount_withdrawn, @id, amount, @balance
    end

    def do_withdraw(amount)
      @balance -= amount
    end

    def replay(event)
      case event[:name]
      when :account_created
        @balance = event[:initial_balance]
      when :amount_withdrawn
        do_withdraw event[:amount]
      end
    end
  end

  class EventStorage
    def initialize
      @account_events = Hash.new {|h, k| h[k] = [] }
    end

    def account_created(account_id, initial_balance)
      @account_events[account_id] << {:name => :account_created, :account_id => account_id, :initial_balance => initial_balance }
    end

    def amount_withdrawn(account_id, amount, new_balance)
      @account_events[account_id] << {:name => :amount_withdrawn, :account_id => account_id, :amount => amount, :new_balance => new_balance}
    end

    def fetch_events(account_id)
      @account_events[account_id]
    end
  end

  class ReportingStorage
    def initialize
      @account_balances = Hash.new {|h, k| hash[k] = [] }
    end

    def account_created(account_id, initial_balance)
      @account_balances[account_id] = initial_balance
    end

    def amount_withdrawn(account_id, amount, new_balance)
      @account_balances[account_id] = new_balance
    end

    def balance_of(account_id)
      @account_balances[account_id]
    end
  end
end
