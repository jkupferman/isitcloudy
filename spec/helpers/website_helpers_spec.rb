require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe WebsiteHelper do
  context "is website on cloud" do
    CLOUDS = Website::CLOUDS.keys

    context "on_cloud?" do
      before do
        @website = Website.new(:url => "cookie.com")
      end

      CLOUDS.each do |cloud|
        it "should return true when it is only on #{cloud.to_s.capitalize}" do
          # This ensures the rest of the on_? methods will always return false
          flexmock(@website).should_receive("pretty_whois").and_return("")

          flexmock(@website).should_receive("on_#{cloud}?").and_return(true)
          @website.on_cloud?.should be_true
        end
      end

      it "should be false when it is not on any of the clouds" do
        CLOUDS.each do |cloud|
          flexmock(@website).should_receive("on_#{cloud}?").and_return(false)
        end

        @website.should_not be_on_cloud
      end
    end

    context "cloud_name" do
      it "should return nil for a new website" do
        Website.new.cloud_name.should be_nil
      end

      it "should return nil when the website isn't on the cloud" do
        @website = Website.new
        flexmock(@website).should_receive(:on_cloud?).and_return(false)
        @website.cloud_name.should be_nil
      end

      it "should return the capitalized string name of Amazon EC2" do
        @website = Website.new
        flexmock(@website).should_receive(:on_ec2?).and_return(true)

        @website.cloud_name.should eql("Amazon EC2")
      end

      it "should return the capitalized string name of the Rackspace cloud" do
        @website = Website.new
        flexmock(@website).should_receive(:on_rackspace?).and_return(true)

        @website.cloud_name.should eql("Rackspace")
      end

      it "should return the capitalized string name of the Linode cloud" do
        @website = Website.new
        flexmock(@website).should_receive(:on_linode?).and_return(true)

        @website.cloud_name.should eql("Linode")
      end
    end

    CLOUDS.each do |cloud|
      context "on_#{cloud.to_s}?" do
        before do
          @method_name = "on_#{cloud.to_s}?"

          @website = Website.new(:url => "testing.com")
        end

        it "should define a #{@method_name} method" do
          @website.respond_to?(@method_name).should be_true
        end

        it "should return true when the whois says it is on #{cloud.to_s.capitalize}" do
          cloud_whois_result = self.send("#{cloud.to_s}_whois")
          flexmock(@website).should_receive(:pretty_whois).and_return(cloud_whois_result)

          @website.send(@method_name).should be_true
        end

        it "should not return true when whois is empty" do
          flexmock(@website).should_receive(:pretty_whois).and_return("")

          @website.send(@method_name).should be_false
        end

        it "should not return true when it is a non-cloud whois" do
          flexmock(@website).should_receive(:pretty_whois).and_return(not_cloud_whois)

          @website.send(@method_name).should be_false
        end

        CLOUDS.each do |other_cloud|
          next if other_cloud == cloud

          it "should not return true when the whois says it on #{other_cloud.to_s.capitalize}" do
            cloud_whois_result = self.send("#{cloud.to_s}_whois")
            flexmock(@website).should_receive(:pretty_whois).and_return(cloud_whois_result)

            @website.send("on_#{other_cloud}?").should be_false
          end
        end
      end
    end

    # Each cloud needs a method that has a valid whois result from that cloud
    def ec2_whois
      """NetRange:       184.72.0.0 - 184.73.255.255 CIDR:           184.72.0.0/15 OriginAS:        NetName:        AMAZON-EC2-7 NetHandle:      NET-184-72-0-0-1 Parent:         NET-184-0-0-0-0 NetType:        Direct Assignment NameServer:     PDNS3.ULTRADNS.ORG NameServer:     PDNS2.ULTRADNS.NET NameServer:     PDNS1.ULTRADNS.NET Comment:"""
    end

    def rackspace_whois
      """NetRange:       74.205.0.0 - 74.205.127.255 CIDR:           74.205.0.0/17 OriginAS:       AS33070, AS10532, AS19994, AS27357 NetName:        RSCP-NET-4 NetHandle:      NET-74-205-0-0-1 Parent:         NET-74-0-0-0-0 NetType:        Direct Allocation NameServer:     NS2.RACKSPACE.COM NameServer:     NS.RACKSPACE.COM RegDate:        2006-11-20 Updated:        2010-05-14 """
    end

    def gogrid_whois
      """NetRange:       74.3.192.0 - 74.3.255.255 CIDR:           74.3.192.0/18 OriginAS:       AS36430, AS26228 NetName:        GOGRID-BLK1 NetHandle:      NET-74-3-192-0-1 Parent:         NET-74-0-0-0-0 NetType:        Direct Allocation NameServer:     NS1.GOGRID.COM NameServer:     NS.GOGRID.COM Comment:        http://www.gogrid.com/ RegDate:        2009-05-18 Updated:        2009-07-15"""
    end

    def joyent_whois
      """NetRange:       72.2.112.0 - 72.2.127.255 CIDR:           72.2.112.0/20 OriginAS:        NetName:        NETWO1924-ARIN NetHandle:      NET-72-2-112-0-1 Parent:         NET-72-0-0-0-0 NetType:        Direct Allocation NameServer:     DNS1.JOYENT.COM NameServer:     DNS2.JOYENT.COM RegDate:        2008-05-14 Updated:        2008-05-14"""
    end

    def linode_whois
      """NetRange:       97.107.128.0 - 97.107.143.255 CIDR:           97.107.128.0/20 OriginAS:        NetName:        LINODE-US NetHandle:      NET-97-107-128-0-1 Parent:         NET-97-0-0-0-0 NetType:        Direct Allocation NameServer:     NS4.LINODE.COM NameServer:     NS1.LINODE.COM NameServer:     NS2.LINODE.COM NameServer:     NS5.LINODE.COM NameServer:     NS3.LINODE.COM Comment:        This block is used for static customer allocations. RegDate:        2008-12-12 Updated:        2010-07-27"""
    end

    def slicehost_whois
      """NetRange:       209.20.64.0 - 209.20.95.255 CIDR:           209.20.64.0/19 OriginAS:       AS12200 NetName:        SLICE-STL-SG NetHandle:      NET-209-20-64-0-1 Parent:         NET-209-0-0-0-0 NetType:        Direct Allocation NameServer:     NS2.SLICEHOST.NET NameServer:     NS1.SLICEHOST.NET Comment:        http://www.slicehost.com RegDate:        2008-03-12 Updated:        2008-07-03"""
    end

    def azure_whois
      """NetRange:       70.37.0.0 - 70.37.191.255 CIDR:           70.37.128.0/18, 70.37.0.0/17 OriginAS:       AS8075 NetName:        MICROSOFT-DYNAMIC-HOSTING NetHandle:      NET-70-37-0-0-1 Parent:         NET-70-0-0-0-0 NetType:        Direct Allocation NameServer:     NS2.MSFT.NET NameServer:     NS4.MSFT.NET NameServer:     NS1.MSFT.NET NameServer:     NS5.MSFT.NET NameServer:     NS3.MSFT.NET Comment:        Abuse complaints will only be responded to if sent to Comment:        abuse@microsoft.com and abuse@msn.com. RegDate:        2008-09-10 Updated:        2009-11-03 """
    end

    def not_cloud_whois
      """NetRange:       64.40.96.0 - 64.40.127.255 CIDR:           64.40.96.0/19 OriginAS:        NetName:        NETNATION NetHandle:      NET-64-40-96-0-1 Parent:         NET-64-0-0-0-0 NetType:        Direct Allocation NameServer:     NS2.NETNATION.COM NameServer:     NS1.NETNATION.COM RegDate:        2000-02-25 Updated:        2005-06-13"""
    end
  end
end
