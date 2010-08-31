require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HelpController, " ABOUT action" do
  it "should route to the /help/about url" do
    assert_recognizes({ :controller => "help", :action => "about" },
                      { :path => "/help/about", :method => :get })
  end

  context "on a GET" do
    before do
      get :about
    end

    it "should be a success" do
      response.should be_success
    end

    it "should render the new template" do
      response.should render_template("about")
    end
  end
end

describe HelpController, " CONTACT action" do
  it "should route to the /help/contact url" do
    assert_recognizes({ :controller => "help", :action => "contact" },
                      { :path => "/help/contact", :method => :get })
  end

  context "on a GET" do
    before do
      get :contact
    end

    it "should be a success" do
      response.should be_success
    end

    it "should render the new template" do
      response.should render_template("contact")
    end
  end

end

describe HelpController, " CREATE action" do
  it "should route create to a POST method" do
    assert_recognizes({ :controller => "help", :action => "create" },
                      { :path => "/help/create", :method => :post })
  end

  context "on a POST" do
    context "with all the necessary fields" do
      before do
        @subject = "I love email subjects"
        @name = "Flava Flav!"
        @email = "flavor@flav.com"
        @body = "YEEEEAHHHHHH BOYHEEEEEEEEEE"

        post :create, { :contact => { :subject => @subject, :name => @name, :email => @email, :body => @body } }
      end

      it "should redirect to the home page" do
        response.should be_redirect
      end

      it "should display a thank you flash message" do
        flash[:info].should_not be_nil
        flash[:info].should match(/Thank you/)
      end
    end

    context "with missing fields" do
      before do
        @subject = "I love email subjects"
        @name = "Flava Flav!"
        @email = "flavor@flav.com"

        post :create, { :contact => { :subject => @subject, :name => @name, :email => @email } }
      end
      
      # Need to add validations to create
      it "should display an error message"
    end
  end
end
