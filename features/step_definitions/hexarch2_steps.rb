Given /^an account (\S+) with a balance of \$(\d+)$/ do |account_id, balance|
  @app.create_account account_id, balance.to_i
end

When /^I withdraw \$(\d+) from (\S+)$/ do |balance, account_id|
  @app.withdraw account_id, balance.to_i
end

Then /^(\S+) should have a balance of \$(\d+)$/ do |account_id, balance|
  @app.balance_of(account_id).should == balance.to_i
end
