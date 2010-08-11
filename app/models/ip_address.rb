require 'ipaddr'

# This class is simply a proxy for the IPAddr class
class IpAddress
  def initialize(ip_address)
    @ip_address = IPAddr.new(ip_address)
  end

  def in? ip_range
    raise ArgumentError unless ip_range.kind_of?(IpRange)

    ip_range.include?(@ip_address)
  end

  private
  def method_missing(method, *args, &block)
    @ip_address.send(method, *args, &block)
  end
end
