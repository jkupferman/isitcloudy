class HelpController < ApplicationController
  before_filter :page_cacher, :only => [:about]
  before_filter :private_page_cacher, :only => [:contact]

  def about
  end
end

