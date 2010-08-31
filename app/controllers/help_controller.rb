class HelpController < ApplicationController
  def about
  end

  def contact
  end

  def create
    if Notification.deliver_contact(params[:contact])
      flash[:info] = "Thank you for your feedback."
      redirect_to root_path
    else
      flash.now[:error] = "An error occurred while sending this email."
      render :contact
    end
  end
end

