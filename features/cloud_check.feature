Feature: Cloud Check
  In order to see if a website is on the cloud
  As a user
  I want to try a website

  Scenario: Visit Home Page
    When I go to the home page
    Then I should see a box for entering a url
    And I should see "on the cloud?"

  Scenario: Submit Non-Cloud Website
    Given I am on the home page
    And I fill in "website_url" with "google.com"
    When I press "Submit"
    Then I should see "No. It is not"
    And I should see a link to "new website page" with text "Try Again?"

  Scenario: Submit Cloud Website
    Given I am on the home page
    And I fill in "website_url" with "rightscale.com"
    When I press "Submit"
    Then I should see "Yes. It is."
    And I should see a link to "new website page" with text "Try Again?"


  Scenario: Submit Blank URL
    Given I am on the home page
    And I fill in "website_url" with ""
    When I press "Submit"
    Then I should be on create website page
    And I should see "Hey, how about giving me an actual website"
