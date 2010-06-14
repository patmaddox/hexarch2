Given /^an account (\S+) with a balance of \$(\d+)$/ do |account_id, balance|
  @app.create_account account_id, balance.to_i
end

When /^I withdraw \$(\d+) from (\S+)$/ do |amount, account_id|
  @app.withdraw account_id, amount.to_i
end

When /^I deposit \$(\d+) into (\S+)$/ do |amount, account_id|
  @app.deposit account_id, amount.to_i
end

When /^I look up the transaction log for (\S+)$/ do |account_id|
  @transaction_log = @app.transaction_log account_id
end

Then /^(\S+) should have a balance of \$(\d+)$/ do |account_id, balance|
  @app.balance_of(account_id).should == balance.to_i
end

Then /^the transaction log should be:$/ do |table|
  expected_log = table.hashes.map {|record| [record['type'].to_sym, record['amount'].to_i, record['ending_balance'].to_i]}
  @transaction_log.should == expected_log
end
