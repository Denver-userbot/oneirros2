require 'nokogiri'
require 'mechanize'

class RivalsAutologin < ApplicationJob
  @queue = :oneirros_ordered
  
  def perform(rivals_id, rivals_hash, rivals_token, session_name = 'oneirros')
    mecha = Mechanize.new
    session_file = "tmp/mechasessions/#{session_name}"

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
