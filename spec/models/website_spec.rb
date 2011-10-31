require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Website do
  it "should have a new method which takes a url string" do
    @website = Website.new(:url => "google.com")
  end

  it "should have a new method which takes no arguments" do
    @website = Website.new
  end

  context "clean_url" do
    it "should correctly parse websites with dashes" do
      Website.new(:url => "www.bd-fans.com").clean_url.should eql("bd-fans.com")
    end
    it "should correctly parse websites with underscores" do
      Website.new(:url => "www.bd_fans.com").clean_url.should eql("bd_fans.com")
    end
    it "should correctly parse websites with numbers" do
      Website.new(:url => "www.bd-fa3ns91.com").clean_url.should eql("bd-fa3ns91.com")
    end
    it "should correctly parse websites with subdomains" do
      Website.new(:url => "http://food-prints.appspot.com/").clean_url.should eql("food-prints.appspot.com")
    end
  end

  context "ip_addresses" do
    it "should return an empty array when no url has been provided" do
      Website.new.ip_addresses.should =~ []
    end

    # FIXME: While useful for initial testing these shouldn't be in unit tests because
    #        a) they have external dependencies 
    #        b) they are slow
    #        These should probably be moved to integration tests

    # it "should fetch the ips of rightscale" do
    #   @actual_ips = ["174.129.230.90", "174.129.238.229"]
    #   @rightscale = Website.new(:url => "rightscale.com")
    #   @rightscale.ip_addresses.should =~ @actual_ips
    # end

    # it "should fetch the ips of facebook" do
    #   @actual_ips = ["69.63.181.12", "69.63.189.11", "69.63.189.16"]

    #   @facebook = Website.new(:url => "facebook.com")
    #   @facebook.ip_addresses.should =~ @actual_ips
    # end

    # context "with different url variations" do
    #   before do
    #     @actual_ips = ["174.129.230.90", "174.129.238.229"]
    #     @actual_url = "rightscale.com"
    #   end

    #   context "with extra url cruft" do
    #     def check_url url
    #       @rightscale = Website.new(:url => url)
    #       @rightscale.ip_addresses.should =~ @actual_ips
    #     end

    #     context "before actual url" do
    #       it "should get ips when www is added to the url" do
    #         check_url("www." + @actual_url)
    #       end

    #       it "should get ips when http://www is added to the url" do
    #         check_url("http://www." + @actual_url)
    #       end

    #       it "should get ips when https://www is added to the url" do
    #         check_url("https://www." + @actual_url)
    #       end

    #       it "should get ips when https://www is added to the url" do
    #         check_url("https://www." + @actual_url)
    #       end

    #       it "should get ips when http:// is added to the url" do
    #         check_url("http://" + @actual_url)
    #       end
    #     end

    #     context "after actual url" do
    #       it "should get ips when a trailing / is added to the url" do
    #         check_url(@actual_url + "/")
    #       end
    #       it "should get ips when a trailing params are added to the url" do
    #         check_url(@actual_url + "?foo=bar&steve=cookiemonster")
    #       end
    #     end      
    #   end

    #   context "with non-.com suffixes" do
    #     it "should get ips with urls that have .edu suffixes" do
    #       @actual_ips = ["128.111.24.40"]
    #       @ucsb = Website.new(:url => "ucsb.edu")
    #       @ucsb.ip_addresses.should =~ @actual_ips
    #     end

    #     it "should get ips with urls that have .co.uk suffixes" do
    #       @actual_ips = ["81.29.92.111"]
    #       @recycle = Website.new(:url => "recycle.co.uk")
    #       @recycle.ip_addresses.should =~ @actual_ips
    #     end

    #     it "should get ips with urls that have .co.il suffixes" do
    #       @actual_ips = ["80.179.238.226"]
    #       @asat = Website.new(:url => "asat.co.il")
    #       @asat.ip_addresses.should =~ @actual_ips
    #     end
    #   end
    # end
  end

  context "whois" do
    it "should return a blank string when no website is provided" do
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

    context "retries" do
      before do
        @website = Website.new(:url => "foo.com")

        @error_result = "ERROR 503: Our server totally blew up"
        @whois_result = "A WHOIS RESULT"
        @ip = "AN IP"

        @client_mock = flexmock("Whois::Client")
      end

      it "should retry when whois returns an error" do
        flexmock(@website).should_receive(:ip_addresses).and_return([@ip])

        flexmock(Whois::Client).should_receive(:new).and_return(@client_mock)
        # Comma seperated return results will return each result in turn, one per call
        flexmock(@client_mock).should_receive(:query).with(@ip).and_return(@error_result, @error_result, @whois_result)

        @website.whois.should eql(@whois_result)
      end

      it "should return an empty whois after the whois query returned too many errors" do
        flexmock(@website).should_receive(:ip_addresses).and_return([@ip])

        flexmock(Whois::Client).should_receive(:new).and_return(@client_mock)
        flexmock(@client_mock).should_receive(:query).with(@ip).and_return(@error_result, @error_result, @error_result)

        @website.whois.should eql("")
      end
    end
  end

  context "hit!" do
    it "should increment the hit counter by one each time it is called" do
      @website = Website.new
      @website.hits.should eql(0)
      @website.hit!
      @website.hits.should eql(1)
      @website.hit!
      @website.hits.should eql(2)
    end
  end
end

