class Ec2
  def self.include? ip_address
    self.ip_ranges.each do |zone, ip_ranges|
      ip_ranges.each do |ip_range|
        return true if ip_range.include?(ip_address)
      end
    end

    false
  end

  private
  def self.ip_ranges
    @@ip_ranges
  end

  @@us_east = [
               IpRange.new("216.182.224.0", 20),
               IpRange.new("72.44.32.0", 19),
               IpRange.new("67.202.0.0", 18),
               IpRange.new("75.101.128.0", 17),
               IpRange.new("174.129.0.0",16),
               IpRange.new("204.236.192.0",18),
               IpRange.new("184.73.0.0",16),
               IpRange.new("184.72.128.0",17)
              ]

  @@us_west = [
               IpRange.new("204.236.128.0",18),
               IpRange.new("184.72.0.0",18)
              ]

  @@eu      = [
               IpRange.new("79.125.0.0", 17)
              ]

  @@ap      = [
               IpRange.new("175.41.128.0", 18)
              ]

  @@ip_ranges = {
    "US East"      => @@us_east,
    "US West"      => @@us_west,
    "EU"           => @@eu,
    "Asia Pacific" => @@ap
  }

end
