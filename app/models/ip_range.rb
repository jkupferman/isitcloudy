require 'ipaddr'

class IpRange
  def initialize(ip, mask_length)
    @ip = IpAddress.new(ip)
    @mask_length = mask_length

    validate_mask_length

    @ip_range = @ip.mask(@mask_length)
  end

  def include? ip_address
    raise ArgumentError unless [IpAddress, IPAddr].include?(ip_address.class)

    @ip_range.include?(ip_address)
  end

  private
  def validate_mask_length
    unless @mask_length.kind_of?(Fixnum)
      raise ArgumentError, "Mask must be an integer - #{@mask_length.to_s}"
    end

    if @mask_length < 0 || @mask_length > 32
      raise ArgumentError, "Invalid mask length, must be between 0-31"
    end
  end
end

