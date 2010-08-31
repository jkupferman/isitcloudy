class Notification < ActionMailer::Base
  CONTACT_EMAIL_ADDRESS = "contact@isitcloudy.com"

  def contact email
    subject "[Contact Us] " << email[:subject]
    recipients CONTACT_EMAIL_ADDRESS
    from email[:email]
    sent_on Time.now.utc

    body :message => email[:body], :name => email[:name]
  end
end
