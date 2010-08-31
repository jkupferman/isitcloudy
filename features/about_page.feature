Feature: About Page
  In order to get more information about
  As a user
  I want to go to an about page

  Scenario: Visit Home Page
    When I go to the about page
    Then I should see "is it cloudy?"
    And I should see a link to "the about page" with text "About"
    And I should see a link to "the contact page" with text "Contact"

