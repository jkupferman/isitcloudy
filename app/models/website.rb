require 'dnsruby'

class Website
  HTTP_PREFIX_REGEX = /https?:\/\//
  WWW_PREFIX_REGEX = /^www\./
  URL_EXTRACT_REGEX = /([\w.]+)/ #/((\w+)([.]\w{3}|[.]\w{2}[.]\w{2}))/

  attr_accessor :url

  def initialize url=nil
    @url = url
    @clean_url = parse(url)
  end

  def url= url
    @url = url
    @clean_url = parse(url)
  end

  def ip_addresses
    @ip_addresses ||= fetch_ip_addresses
  end

  def ==(other)
    self.url == other.url
  end

  private
  def parse input_url
    return nil if input_url.nil?

    url = input_url.to_s.downcase
    url.gsub!(HTTP_PREFIX_REGEX, "")
    url.gsub!(WWW_PREFIX_REGEX, "")

    result = url.match(URL_EXTRACT_REGEX)
    if result.captures.any? && result.captures.length > 1
      url = result.captures.first
    end

    url
  end

  def fetch_ip_addresses
    return [] if @clean_url.nil?

    resolver = Dnsruby::Resolver.new
    result = resolver.query(@clean_url, Dnsruby::Types.A)

    answer = result.answer
    if answer.kind_of?(Dnsruby::Message::Section)
      answer.map { |i| i.address.to_s }.sort.uniq
    else
      [answer.address.to_s]
    end
  end
end
