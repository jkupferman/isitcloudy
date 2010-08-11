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
      @actual_ips = ["69.63.181.12", "69.63.189.11", "69.63.189.16", "69.63.181.11"]

      @facebook = Website.new("facebook.com")
      @facebook.ip_addresses.should =~ @actual_ips
    end

    context "with different url variations" do
      context ""
      before do
        @actual_ips = ["174.129.230.90", "174.129.238.229"]
        @actual_url = "rightscale.com"
      end

      context "before actual url" do
        def check_url url
          @rightscale = Website.new(url)
          @rightscale.ip_addresses.should =~ @actual_ips
        end

        it "should get ips when www is added to the url" do
          check_url("www." + @actual_url)
        end

        it "should get ips when http://www is added to the url" do
          check_url("http://www." + @actual_url)
        end

        it "should get ips when https://www is added to the url" do
          check_url("https://www." + @actual_url)
        end

        it "should get ips when https://www is added to the url" do
          check_url("https://www." + @actual_url)
        end

        it "should get ips when http:// is added to the url" do
          check_url("http://" + @actual_url)
        end
      end

      context "with .com suffixes" do
        it "should work with urls that have .edu suffixes"
        it "should work with urls that have .co.uk suffixes"
        it "should work with urls that have .co.jp suffixes"
      end
    end
  end
end

