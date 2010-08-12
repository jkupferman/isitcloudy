require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe WebsitesController, " NEW action" do
  it "should route to the root url" do
    assert_recognizes({ :controller => "websites", :action => "new" }, 
                      { :path => "/", :method => :get })
  end

  it "should route to the /websites/ url" do
    assert_recognizes({ :controller => "websites", :action => "new" }, 
                      { :path => "/websites/new", :method => :get })
  end

  context "on a GET" do
    before do
      get :new
    end
    it "should assign a website object" do
      assigns(:website).should_not be_nil
    end

    it "should be a success" do
      response.should be_success
    end

    it "should render the new template" do
      response.should render_template("new")
    end
  end
end

describe WebsitesController, " CREATE action" do
  it "should route create to a POST method" do
    assert_recognizes({ :controller => "websites", :action => "create" }, 
                      { :path => "/websites/create", :method => :post })
  end
  
  context "on a POST" do
    before do
      @url = "http://www.google.com" 

      @website = flexmock("website")
      flexmock(Website).should_receive(:new).with("url" => @url).and_return(@website)

      flexmock(@website).should_receive("save!")

      post :create, { :website => { :url => @url } }
    end

    it "should create a website object with the provided url" do
      assigns(:website).should_not be_nil
      assigns(:website).should eql(@website)
    end
    
    it "should redirect to the show action" do
      response.should be_redirect
      #TODO: How can I check that it did the show action
    end
  end

end

describe WebsitesController, " SHOW action" do
  it "should route to the show method" do
    @id = 15
    assert_recognizes({ :controller => "websites", :action => "show", :id => @id.to_s },
                      { :path => "/websites/#{@id}", :method => :get })
  end

  context "on a GET" do
    before do
      @id = 131
      @website = flexmock("website")

      flexmock(Website).should_receive(:find_by_id).with(@id.to_s).and_return(@website)

      get :show, :id => @id
    end

    it "should be a success" do
      response.should be_success
    end

    it "should assign a website object" do
      assigns(:website).should_not be_nil
      assigns(:website).should eql(@website)
    end

    it "should render the show template" do
      response.should render_template("show")
    end
  end
end
