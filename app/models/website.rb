require 'whois'
require 'resolv'

class Website < ActiveRecord::Base
  include WebsiteHelper

  HTTP_PREFIX_REGEX = /https?:\/\//
  WWW_PREFIX_REGEX = /^www\./
  URL_EXTRACT_REGEX = /([\w\d\-_.]+)/

  WHOIS_ERROR_REGEX = /ERROR [\d]+:/
  WHOIS_RETRY_ATTEMPTS = 3

  validates_presence_of :url, :clean_url, :ip_addresses

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
    # Lazily parse the url, then cache it
    self[:clean_url] ||= Website.parse_url(self.url)
  end

  def link
    "http://" + self.clean_url.to_s
  end

  private
  def self.parse_url input_url
    return nil if input_url.nil?

    url = input_url.to_s.downcase
    url.gsub!(HTTP_PREFIX_REGEX, "")
    url.gsub!(WWW_PREFIX_REGEX, "")

    result = url.match(URL_EXTRACT_REGEX)
    if result && result.captures.any? && result.captures.length >= 1
      url = result.captures.first
    end

    url
  end

  def fetch_ip_addresses
    return [] if self.clean_url.nil?

    result = []
    begin
      result = Resolv::DNS.open { |d| d.getresources(self.clean_url, Resolv::DNS::Resource::IN::A) }
    rescue Exception => e
      Rails.logger.info("IP Address lookup failed for URL: #{self.clean_url.to_s} \n#{e.pretty_printer}")
    end


    result.map { |i| i.address.to_s if i.respond_to?(:address) }.compact.sort.uniq
  end


  def fetch_whois
    return "" if self.ip_addresses.empty?

    attempt = 0
    begin
      client = Whois::Client.new(:timeout => 5)
      result = client.query(self.ip_addresses.first).to_s
      raise ServerException.new(result) if WHOIS_ERROR_REGEX =~ result
      result
    rescue ServerException => e
      Rails.logger.info("ServerException caught for URL #{self.url.to_s}: #{e.message.to_s}")
      attempt += 1
      retry unless attempt > WHOIS_RETRY_ATTEMPTS

      Rails.logger.error("Whois lookup failed for URL #{self.url.to_s} after #{WHOIS_RETRY_ATTEMPTS} attempts")
      ""
    rescue SocketError, Timeout::Error => e
      Rails.logger.info("Whois lookup failed for URL: #{self.url.to_s} \n#{e.pretty_printer}")
      ""
    end
  end

  class ServerException < Exception; end
end
