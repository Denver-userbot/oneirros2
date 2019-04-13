require 'kimurai'
require 'pp'

class RegionsBootstrapSpider < RivalRegionsAuthedSpider
  @engine = :mechanize
  @authed_url = "http://rivalregions.com/info/regions"
 
  def parse_authed(response, url:, data: {})
    skipfirst = true
    response.css('tr').each do |row|
      # Skip heading
      if not skipfirst
        col = row.css('td').first
        rivalid = col.text.squish.split(':').last.squish.to_i
        request_to :parse_region, url: "http://rivalregions.com/listed/region/#{rivalid}", data: { :rivals_id => rivalid }
        sleep 5
      end
      skipfirst = false
    end
  end

  def parse_region(response, url:, data: {})
    regname = response.css(".slide_title .slide_link_action").first.text.squish
    RivalRegion.where(rivals_id: data[:rivals_id]).first_or_create do |instance|
      instance.name_en = regname
    end
  end
end
