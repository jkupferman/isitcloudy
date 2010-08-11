require 'ipaddr'

class IpRange
  def initialize(ip, mask_length)
    @ip = IpAddress.new(ip)
    @mask_length = mask_length

    validate_mask_length

    @ip_range = @ip.mask(@mask_length)
  end

  def include? ip_address
    raise ArgumentError unless ip_address.kind_of?(IpAddress)

    ip_address.mask(@mask_length) == @ip_range
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

