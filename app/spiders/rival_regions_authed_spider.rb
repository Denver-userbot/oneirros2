require 'kimurai'
require 'pp'

class RivalRegionsAuthedSpider < Kimurai::Base
  # Accessor for Class Variable
  class << self
    attr_accessor :authed_url
  end

  def self.authed_parse!()
    # Retrieve credentials from Rails
    rivals_id = Rails.application.credentials.dig :rivals, :id
    rivals_token = Rails.application.credentials.dig :rivals, :token
    rivals_hash = Rails.application.credentials.dig :rivals, :hash

    # Send request and process
    return self.parse!(:authed_callback_now, url: "http://rivalregions.com/?viewer_id=#{rivals_id}&id=#{rivals_id}&access_token=#{rivals_token}&hash=#{rivals_hash}")
  end

  def auth
    # Retrieve credentials from Rails
    rivals_id = Rails.application.credentials.dig :rivals, :id
    rivals_token = Rails.application.credentials.dig :rivals, :token
    rivals_hash = Rails.application.credentials.dig :rivals, :hash

    # Send request and process
    return request_to :authed_callback, url: "http://rivalregions.com/?viewer_id=#{rivals_id}&id=#{rivals_id}&access_token=#{rivals_token}&hash=#{rivals_hash}"
  end
  
  def parse_authed(response, url:, data: {})
    # Override me
  end

  def authed_callback(response, url:, data: {})
    # Do nothing for interactive mode
  end

  def authed_callback_now(response, url:, data: {})
    go
  end
  
  def go
    request_to :parse_authed, url: self.class.authed_url
  end


  def authed_check(response) 
    logged_out = /Session expired, please, reload the page/ =~ response.css("script").text
    if (logged_out.nil?)
      return true
    end
    return false
  end
end
