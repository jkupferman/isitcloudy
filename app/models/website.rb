require 'dnsruby'

class Website
  def initialize url
    @url = url
  end

  def ip_addresses
    @ip_addresses ||= fetch_ip_addresses
  end

  private
  def fetch_ip_addresses
    resolver = Dnsruby::Resolver.new
    result = resolver.query(@url, Dnsruby::Types.A)

    answer = result.answer
    if answer.kind_of?(Dnsruby::Message::Section)
      answer.map { |i| i.address.to_s }.sort.uniq
    else
      [answer.address.to_s]
    end
  end
end
