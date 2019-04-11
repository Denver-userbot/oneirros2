require 'nokogiri'
require 'mechanize'

class OneirrosOrderedJobHandler < ApplicationJob
  @queue = :oneirros_ordered
 
  def perform(type, args = {}) 
    if type == "autologin"
      self.perform_autologin(args)
    else
      Rails.logger.info "Got unrecognized task type in ordered queue: #{type}"
    end
  end 
 
  def perform_autologin(args = {})
    mecha = Mechanize.new
    session_name = args.session_name || "oneirros"
    session_file = "tmp/mechasessions/#{session_name}"

    # Load credentials for login
    rivals_id = Rails.application.credentials.dig :rivals, :id
    rivals_token = Rails.application.credentials.dig :rivals, :token
    rivals_hash = Rails.application.credentials.dig :rivals, :hash

    # Check session first if we already have one
    if File.file?(session_file)
      mecha.cookie_jar.load(session_file)
      result = mecha.get("http://rivalregions.com/slide/profile/0")
      check = /Session expired, please, reload the page/ =~ result.css("script").text
      if check.nil? 
        return
      end
    end

    # If we got here, our PHP session is invalid. Attempt to relog.
    result = mecha.get("https://rivalregions.com/?viewer_id=#{rivals_id}&id=#{rivals_id}&access_token=#{rivals_token}&hash=#{hash}")
    mecha.cookie_jar.save(session_file)

    # TODO: Add failure condition in case new login also fails (expired token, account banned?)
  end
 

end
