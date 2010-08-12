require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Ec2 do
  context "include?" do
    it "should include an address in the US East region" do
      Ec2.should include(IpAddress.new("216.182.225.0"))
    end
    it "should include an address in the US West region" do
      Ec2.should include(IpAddress.new("184.72.63.255"))
    end
    it "should include an address in the EU region" do
      Ec2.should include(IpAddress.new("79.125.100.1"))
    end
    it "should include an address in the AP region" do
      Ec2.should include(IpAddress.new("175.41.128.55"))
    end
  end
end
