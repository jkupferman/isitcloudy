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

  helper_method :page_cacher
  helper_method :private_page_cacher

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

  def page_cacher visibility=:public, duration=1.hour
    if ActionController::Base.perform_caching && request.method == :get && flash.keys.empty?
      response.headers['Cache-Control'] = "#{visibility.to_s}, max-age=#{duration.to_i.to_s}"
    end
  end

  def private_page_cacher duration=10.minutes
    page_cacher :private, duration
  end
end
