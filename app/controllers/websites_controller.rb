class WebsitesController < ApplicationController
  def new
    @website = Website.new
  end

  def create
    # Handle the url param for requests that go to /q?url=foo.com
    @website = Website.new(params[:website] || { :url => params[:url] })

    if @website.save
      redirect_to website_url(@website)
    else
      flash.now[:notice] = "Hey, how about giving me an actual website."
      render :new
    end
  end

  def show
    @website = Website.find_by_id(params[:id])

    if @website.nil?
      flash[:error] = "Totally not cool. Try a real one next time."
      redirect_to new_website_path
    end
  end
end
