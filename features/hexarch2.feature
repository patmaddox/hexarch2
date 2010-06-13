Feature: Withdrawing money from an account
  Scenario: Enough money in account to cover request
    Given an account abc123 with a balance of $500
    When I withdraw $200 from abc123
    Then abc123 should have a balance of $300