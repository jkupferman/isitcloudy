require 'dnsruby'
require 'whois'

class Website < ActiveRecord::Base
  HTTP_PREFIX_REGEX = /https?:\/\//
  WWW_PREFIX_REGEX = /^www\./
  URL_EXTRACT_REGEX = /([\w.]+)/ #/((\w+)([.]\w{3}|[.]\w{2}[.]\w{2}))/

  validates_presence_of :url

  def ip_addresses
    @ip_addresses ||= fetch_ip_addresses
  end

  def whois
    @whois ||= fetch_whois
  end

  def clean_url
    # return the url if its already been set, otherwise parse and assign it
    super || self.clean_url = parse_url(self.url)
  end

  private
  def parse_url input_url
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
    return [] if self.clean_url.nil?

    resolver = Dnsruby::Resolver.new
    result = resolver.query(self.clean_url, Dnsruby::Types.A)

    answer = result.answer
    if answer.kind_of?(Dnsruby::Message::Section)
      answer.map { |i| i.address.to_s }.sort.uniq
    else
      [answer.address.to_s]
    end
  end

  def fetch_whois
    return "" if self.ip_addresses.empty?

    client = Whois::Client.new
    client.query(self.ip_addresses.first)
  end
end
