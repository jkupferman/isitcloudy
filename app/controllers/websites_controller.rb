class WebsitesController < ApplicationController
  def new
    @website = Website.new
  end

  def create
    @website = Website.new(params[:website])

    @website.save!

    redirect_to websites_url(@website)
  end

  def show
    @website = Website.find_by_id(params[:id])
  end
end
