# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

# Include any monkey patches which have been defined
require File.join(Rails.root, 'lib', 'monkey_patches')

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  layout "default"
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # Temporarily require authentication before we release it publicly
  before_filter :authenticate

  rescue_from Exception, :with => :rescue_all_exceptions if Rails.env.production?

  private
  def rescue_all_exceptions(exception)
    Notification.deliver_error(exception,
                               clean_backtrace(exception),
                               session,
                               params,
                               request.env
                               )

    render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
  end

  VALID_LOGINS = {
    "admin" => "cl0ud404",
    "test" => "IsCl0udy"
  }

  def authenticate
    if Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        VALID_LOGINS.has_key?(username) && VALID_LOGINS[username] == password
      end
    end
  end
end
