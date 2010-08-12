class WebsitesController < ApplicationController

  def new
    @website = Website.new
  end
end
