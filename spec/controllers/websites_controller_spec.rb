require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe WebsitesController, " NEW action" do
  it "should route to the root url" do
    assert_recognizes({ :controller => "websites", :action => "new"}, 
                      { :path => "/", :method => :get})
  end

  it "should route to the /websites/ url" do
    assert_recognizes({ :controller => "websites", :action => "new"}, 
                      { :path => "/websites/", :method => :get})
  end
end

describe WebsitesController, " SHOW action" do
end
