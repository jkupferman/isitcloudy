class Notification < ActionMailer::Base
  EMAIL_DOMAIN = "isitcloudy.com"
  CONTACT_EMAIL = "contact@#{EMAIL_DOMAIN}"
  ERROR_EMAIL = "error@#{EMAIL_DOMAIN}"
  ERROR_NOTIFIER_EMAIL = "error@#{EMAIL_DOMAIN}"

  def contact email
    subject "[Contact Us] " << email[:subject]
    recipients CONTACT_EMAIL
    from email[:email]
    sent_on Time.now.utc

    body :message => email[:body], :name => email[:name]
  end

  def error exception, trace, session, params, env
    subject "[Error] " << env['REQUEST_URI']
    recipients ERROR_EMAIL
    from ERROR_NOTIFIER_EMAIL
    sent_on Time.now.utc

    body :exception => exception, :trace => trace, :session => session, :params => params, :env => env
  end

end
