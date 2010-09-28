class Notification < ActionMailer::Base
  CONTACT_EMAIL  = "isitcloudymailer+contact@gmail.com"
  ERROR_EMAIL    = "isitcloudymailer+error@gmail.com"
  NOTIFIER_EMAIL = "isitcloudywebsite@gmail.com"

  def contact email
    subject "[Contact Us] " << email[:subject]
    recipients CONTACT_EMAIL
    from NOTIFIER_EMAIL
    sent_on Time.now.utc

    body :message => email[:body], :name => email[:name], :reply_to => email[:email]
  end

  def error exception, trace, session, params, env
    subject "[Error] " << env['REQUEST_URI'] << " " << exception.message
    recipients ERROR_EMAIL
    from NOTIFIER_EMAIL
    sent_on Time.now.utc

    body :exception => exception, :trace => trace, :session => session, :params => params, :env => env
  end
end
