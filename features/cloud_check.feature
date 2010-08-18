Feature: Cloud Check
  In order to see if a website is on the cloud
  As a user
  I want to try a website

  Scenario: Visit Home Page
    When I go to the home page
    Then I should see a box for entering a url
    And I should see "on the cloud?"

  Scenario: Submit Website
    Given I am on the home page
    And I fill in "website_url" with "google.com"
    When I press "Submit"
    Then I should see "No. It is not"
