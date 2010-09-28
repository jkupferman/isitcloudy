class WebsitesController < ApplicationController
  before_filter :page_cacher, :only => [:show]
  # Make the new action private to ensure valid authenticity tokens
  before_filter :private_page_cacher, :only => [:new]

  def new
    @website = Website.new
  end

  def create
    # Handle the url param for requests that go to /q?url=foo.com
    inputs = params[:website] || { :url => params[:url] }
    @website = Website.find_or_initialize_by_clean_url(Website.parse_url(inputs[:url]), inputs)

    @website.hit!

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
      redirect_to new_website_path(:msg => "error")
    end
  end
end
