require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Website do
  it "should have a new method which takes a url string" do
    @website = Website.new("google.com")
  end

  context "ip_addresses" do
    it "should fetch the ips of rightscale" do
      @actual_ips = ["174.129.230.90", "174.129.238.229"]
      @rightscale = Website.new("rightscale.com")
      @rightscale.ip_addresses.should =~ @actual_ips
    end

    it "should fetch the ips of facebook" do
      @actual_ips = [ "69.63.181.12", "69.63.189.11", "69.63.189.16", "69.63.181.11"]

      @facebook = Website.new("facebook.com")
      @facebook.ip_addresses.should =~ @actual_ips
    end
  end

end

