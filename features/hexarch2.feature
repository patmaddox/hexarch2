Feature: Withdrawing money from an account
  Scenario: Enough money in account to cover request
    Given an account abc123 with a balance of $500
    When I withdraw $200 from abc123
    Then abc123 should have a balance of $300

  Scenario: Account has transaction log
    Given an account abc123 with a balance of $500
    When I withdraw $200 from abc123
    And I deposit $100 into abc123
    When I look up the transaction log for abc123
    Then the transaction log should be:
      | type   | amount | ending_balance |
      | credit | 500    | 500            |
      | debit  | 200    | 300            |
      | credit | 100    | 400            |