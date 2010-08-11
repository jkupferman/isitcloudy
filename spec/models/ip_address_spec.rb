require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe IpAddress do
  it "should have a new method which takes in a string IP" do
    @ip = IpAddress.new("192.168.1.1")
  end

  context "with an invalid ip address" do
    it "a text string should raise an ArgumentError" do
      lambda { IpAddress.new("foo") }.should raise_error(ArgumentError)
    end

    it "an ip that is too short should raise an ArgumentError" do
      lambda { IpAddress.new("192.") }.should raise_error(ArgumentError)
    end

    it "and ip that is too long should raise an ArgumentError" do
      lambda { IpAddress.new("192.168.1.1.1") }.should raise_error(ArgumentError)
    end

    it "an ip with a number larger than 255 should raise an ArgumentError" do
      lambda { IpAddress.new("192.260.1.1") }.should raise_error(ArgumentError)
    end
  end

  context "in?" do
    it "all ips should be in any range when the mask is 0" do
      @range = IpRange.new("192.168.1.1", 0)

      IpAddress.new("192.168.1.1").should be_in(@range)
      IpAddress.new("0.0.0.0").should be_in(@range)
      IpAddress.new("255.255.255.255").should be_in(@range)
    end

    it "should only include the exact ip when the mask is 32" do
      @range = IpRange.new("220.2.2.2", 32)
      
      IpAddress.new("220.2.2.2").should be_in(@range)
     
      IpAddress.new("220.2.2.3").should_not be_in(@range)
      IpAddress.new("220.255.255.1").should_not be_in(@range)
    end

    it "should include both the smallest and largest possible ip in a range" do
      @range = IpRange.new("120.50.0.0", 16)

      IpAddress.new("120.50.0.0").should be_in(@range), "the smallest IP in the range"
      IpAddress.new("120.50.255.255").should be_in(@range), "the largest IP in the range"
    end
  end
end
