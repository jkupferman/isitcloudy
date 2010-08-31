require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Notification do
  context "Contact Us" do
    context "Given an email" do
      # For tips on testing actionmailer models
      # See http://www.rubytutorials.net/2008/02/26/small-rspec-revelations-actionmailer/
      it "should send have a subject"
      it "should set the from address"
      it "should set the time"
      it "should set the message body"
    end
  end
end

