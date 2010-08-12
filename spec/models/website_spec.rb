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

      it "should get ips when a trailing / is added to the url"
      it "should get ips when a trailing params are added to the url"
      
      context "with non-.com suffixes" do
        it "should get ips with urls that have .edu suffixes" do
          @actual_ips = ["128.111.24.40"]
          @ucsb = Website.new("ucsb.edu")
          @ucsb.ip_addresses.should =~ @actual_ips
        end

        it "should get ips with urls that have .co.uk suffixes" do
          @actual_ips = ["208.46.17.17","208.46.17.10"]
          @bbc = Website.new("telegraph.co.uk")
          @bbc.ip_addresses.should =~ @actual_ips
        end

        it "should get ips with urls that have .co.il suffixes" do
          @actual_ips = ["80.179.238.226"]
          @asat = Website.new("asat.co.il")
          @asat.ip_addresses.should =~ @actual_ips
        end
      end
    end
  end
end

