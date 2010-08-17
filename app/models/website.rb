require 'dnsruby'
require 'whois'

class Website < ActiveRecord::Base
  HTTP_PREFIX_REGEX = /https?:\/\//
  WWW_PREFIX_REGEX = /^www\./
  URL_EXTRACT_REGEX = /([\w.]+)/ #/((\w+)([.]\w{3}|[.]\w{2}[.]\w{2}))/

  SUPPORTED_CLOUDS = [:ec2, :rackspace, :gogrid, :joyent, :linode]

  EC2_REGEX = /AMAZON-EC2-[\d]+/
  RACKSPACE_REGEX = /RSCP-NET-[\d]+/
  GOGRID_REGEX = /GOGRID-BLK[\d]+/
  JOYENT_REGEX = /NETWO1924-ARIN/
  LINODE_REGEX = /LINODE-US/

  validates_presence_of :url

  def ip_addresses
    @ip_addresses ||= fetch_ip_addresses
  end

  def whois
    @whois ||= fetch_whois
  end

  def pretty_whois
    @pretty_whois ||= self.whois.split("\n").delete_if {|l| l.empty? || l.start_with?("#") }.join(" ")
  end

  def clean_url
    @cleaned_url ||= Website.parse_url(self.url)
  end

  def on_cloud?
    on_ec2? || on_rackspace? || on_gogrid? || on_joyent? || on_linode?
  end

  def on_ec2?
    ! EC2_REGEX.match(self.pretty_whois).nil?
  end

  def on_rackspace?
    ! RACKSPACE_REGEX.match(self.pretty_whois).nil?
  end

  def on_gogrid?
    ! GOGRID_REGEX.match(self.pretty_whois).nil?
  end

  def on_joyent?
    ! JOYENT_REGEX.match(self.pretty_whois).nil?
  end

  def on_linode?
    ! LINODE_REGEX.match(self.pretty_whois).nil?
  end

  private
  def self.parse_url input_url
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

    resolver = Dnsruby::Resolver.new(:packet_timeout => 1, :query_timeout => 1, :retry_times => 2)
    begin
      result = resolver.query(self.clean_url, Dnsruby::Types.A)
    rescue Dnsruby::ServFail, Dnsruby::NXDomain, Dnsruby::ResolvTimeout => e
      Rails.logger.info("IP Address lookup failed for URL: #{self.url.to_s} \n#{e.pretty_printer}")
      return []
    end

    answer = result.answer
    if answer.kind_of?(Dnsruby::Message::Section)
      answer.map { |i| i.address.to_s if i.respond_to?(:address) }.compact.sort.uniq
    else
      [answer.address.to_s]
    end
  end

  def fetch_whois
    return "" if self.ip_addresses.empty?

    client = Whois::Client.new
    begin
      client.query(self.ip_addresses.first).to_s
    rescue SocketError, Timeout::Error => e
      Rails.logger.info("Whois lookup failed for URL: #{self.url.to_s} \n#{e.pretty_printer}")
      ""
    end
  end
end
