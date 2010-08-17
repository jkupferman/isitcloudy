require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Website do
  it "should have a new method which takes a url string" do
    @website = Website.new(:url => "google.com")
  end

  it "should have a new method which takes no arguments" do
    @website = Website.new
  end

  context "ip_addresses" do
    it "should return an empty array when no url has been provided" do
      Website.new.ip_addresses.should =~ []
    end

    it "should fetch the ips of rightscale" do
      @actual_ips = ["174.129.230.90", "174.129.238.229"]
      @rightscale = Website.new(:url => "rightscale.com")
      @rightscale.ip_addresses.should =~ @actual_ips
    end

    it "should fetch the ips of facebook" do
      @actual_ips = ["69.63.181.12", "69.63.189.11", "69.63.189.16", "69.63.181.11"]

      @facebook = Website.new(:url => "facebook.com")
      @facebook.ip_addresses.should =~ @actual_ips
    end

    context "with different url variations" do
      before do
        @actual_ips = ["174.129.230.90", "174.129.238.229"]
        @actual_url = "rightscale.com"
      end

      context "before actual url" do
        def check_url url
          @rightscale = Website.new(:url => url)
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
          @ucsb = Website.new(:url => "ucsb.edu")
          @ucsb.ip_addresses.should =~ @actual_ips
        end

        it "should get ips with urls that have .co.uk suffixes" do
          @actual_ips = ["208.46.17.17","208.46.17.10"]
          @bbc = Website.new(:url => "telegraph.co.uk")
          @bbc.ip_addresses.should =~ @actual_ips
        end

        it "should get ips with urls that have .co.il suffixes" do
          @actual_ips = ["80.179.238.226"]
          @asat = Website.new(:url => "asat.co.il")
          @asat.ip_addresses.should =~ @actual_ips
        end
      end
    end
  end

  context "whois" do
    it "should return a bank string when no website is provided" do
      Website.new.whois.should eql("")
    end

    it "should return a blank string when no ip addresses are available" do
      @website = Website.new(:url => "foo.com")
      flexmock(@website).should_receive(:ip_addresses).and_return([])

      @website.whois.should eql("")
    end

    it "should return a whois when called with an IP" do
      @website = Website.new(:url => "foo.com")

      @whois_result = "A WHOIS RESULT"
      @ip = "AN IP"
      flexmock(@website).should_receive(:ip_addresses).and_return([@ip])

      @client_mock = flexmock("Whois::Client")
      flexmock(Whois::Client).should_receive(:new).once.and_return(@client_mock)
      flexmock(@client_mock).should_receive(:query).once.with(@ip).and_return(@whois_result)

      @website.whois.should eql(@whois_result)
    end
  end
end

