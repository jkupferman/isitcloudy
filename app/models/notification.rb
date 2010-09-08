class Notification < ActionMailer::Base
  CONTACT_EMAIL        = "isitcloudywebsite+contact@gmail.com"
  ERROR_EMAIL          = "isitcloudywebsite+error@gmail.com"
  ERROR_NOTIFIER_EMAIL = "isitcloudywebsite+notifier@gmail.com"

  def contact email
    subject "[Contact Us] " << email[:subject]
    recipients CONTACT_EMAIL
    from email[:email]
    sent_on Time.now.utc

    body :message => email[:body], :name => email[:name]
  end

  def error exception, trace, session, params, env
    subject "[Error] " << env['REQUEST_URI'] << " " << exception.message
    recipients ERROR_EMAIL
    from ERROR_NOTIFIER_EMAIL
    sent_on Time.now.utc

    body :exception => exception, :trace => trace, :session => session, :params => params, :env => env
  end
end
