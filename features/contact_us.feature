Feature: Contact Us Page
  In order to get in contact with the authors
  As a user
  I want to be able to send them a message

  Scenario: Visit Contact Page
    When I go to the contact page
    Then I should see a form with a "textarea" element
    And I should see a "Send" button

  Scenario: Submit Contact Page
    When I go to the contact page
    And I fill in "contact_subject" with "Your website r0cks my s0cks"
    And I fill in "contact_name" with "Bjorn Borg"
    And I fill in "contact_email" with "foobars@fakeemail.com"
    And I fill in "contact_body" with "Just wanted to let you know that your website is da bomb!"
    And I press "Send"
    Then I should be on the home page
    And I should see "Thank you"

