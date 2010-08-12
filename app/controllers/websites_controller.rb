class WebsitesController < ApplicationController
  def new
    @website = Website.new
  end

  def create
    @website = Website.new(params[:website])

    if @website.save
      redirect_to websites_url(@website)
    else
      flash[:notice] = "Hey, how about giving me an actual website."
      render :new
    end
  end

  def show
    @website = Website.find_by_id(params[:id])

    if @website.nil?
      flash[:error] = "Totally not cool. Try a real one next time."
      render :new
    end
  end
end
