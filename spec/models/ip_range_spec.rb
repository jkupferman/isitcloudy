require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe IpRange do
  it "should have a new method which takes in a string IP and subnet mask" do
    @ip_range = IpRange.new("192.168.1.1", 20)
  end

  context "with an invalid ip address" do
    it "a text string should raise an ArgumentError" do
      lambda { IpRange.new("foo", 32) }.should raise_error(ArgumentError)
    end

    it "an ip that is too short should raise an ArgumentError" do
      lambda { IpRange.new("192.", 32) }.should raise_error(ArgumentError)
    end

    it "and ip that is too long should raise an ArgumentError" do
      lambda { IpRange.new("192.168.1.1.1", 32) }.should raise_error(ArgumentError)
    end

    it "an ip with a number larger than 255 should raise an ArgumentError" do
      lambda { IpRange.new("192.260.1.1", 32) }.should raise_error(ArgumentError)
    end
  end

  context "with an invalid subnet mask" do
    it "a string subnet mark should raise an ArgumentError" do
      lambda { IpRange.new("192.168.1.1", "hello") }.should raise_error(ArgumentError)
    end

    it "a negative subnet mask should raise an ArgumentError" do
      lambda { IpRange.new("192.168.1.1", -6) }.should raise_error(ArgumentError)
    end

    it "a huge subnet mask should raise an ArgumentError" do
      lambda { IpRange.new("192.168.1.1", 600) }.should raise_error(ArgumentError)
    end
  end

  context "include?" do
    it "should include any ip when the mask is 0" do
      @range = IpRange.new("192.168.1.1", 0)
      @range.should include(IpAddress.new("192.168.1.1"))
      @range.should include(IpAddress.new("0.0.0.0"))
      @range.should include(IpAddress.new("255.255.255.255"))
    end

    it "should only include the exact ip when the mask is 32" do
      @range = IpRange.new("220.2.2.2", 32)
      @range.should include(IpAddress.new("220.2.2.2"))
      
      @range.should_not include(IpAddress.new("220.2.2.3"))
      @range.should_not include(IpAddress.new("220.255.255.1"))
    end

    it "should include both the smallest and largest possible ip in a range" do
      @range = IpRange.new("120.50.0.0", 16)

      @range.should include(IpAddress.new("120.50.0.0")), "the smallest IP in the range"
      @range.should include(IpAddress.new("120.50.255.255")), "the largest IP in the range"
    end
  end
end
