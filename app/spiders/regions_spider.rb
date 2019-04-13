require 'kimurai'

class RegionsSpider < Kimurai::Base
  @engine = :mechanize
  @start_urls = [ "http://rivalregions.com/slide/profile/0" ]

  def login(response, url:, data: {})
    #  Nothing to do ? Spider keeps session cookies.
  end

  def regions(response, url:, data: {})

  ru_map = {
        "РЕГИОН" => "name",
        "АВТ" => "is_autonomy",
        "да" => true,
        "нет" => false,
        "НАС" => "citizens",
        "ПРО" => "residents",
        "ВА" => "initial_atk",
        "УЗ" => "initial_def",
        "ГО" => "hospital",
        "ВО" => "military_base",
        "ШК" => "school",
        "ПВ" => "missile",
        "ПО" => "port",
        "ЭЛ" => "power_plant",
        "КО" => "spaceport",
        "АЭ" => "airport",
        "ЖФ" => "housing_fund",
        "ЗОЛ" => "gold_now",
        "НЕФ" => "oil_now",
        "РУД" => "ore_now",
        "УРА" => "ura_now",
        "АЛМ" => "dia_now",
        "ЗОЛ Р" => "gold_base",
        "НЕФ Р" => "oil_base",
        "РУД Р" => "ore_base",
        "УРА Р" => "ura_base",
        "АЛМ Р" => "dia_base",
        "ЗОЛ В" => "gold_max",
        "НЕФ В" => "oil_max",
        "РУД В" => "ore_max",
        "УРА В" => "ura_max",
        "АЛМ В" => "dia_max",
        "ИНД О" => "edu_index",
        "ИНД В" => "mil_index",
        "ИНД М" => "med_index",
        "ИНД Р" => "dev_index"
  }

    # Get columns from table
    colnames = Array.new
    response.css('th').each do |col|
      colnames << col.text.squish
    end
    response.css('tr').each do |row|
      rowhash = Hash.new
      header = colnames.to_enum
      row.search('td').each do |col|
        colname = ru_map[header.next]
        colval = col.text.squish
        if colname == "is_autonomy"
          rowhash[colname] = ru_map[colval]
        elsif colname == "name"
          rowhash["rivals_id"] = colval.split(':').last.squish.to_i
        else
          rowhash[colname] = colval.to_i
        end

        # Stop processing after dev_index because there's duplicates
        if colname == "dev_index"
          break
        end
      end

      RivalRegionMetrics.write(rowhash)
    end
  end 

  def parse(response, url:, data: {}) 
    # Check if we are logged out
    logged_out = /Session expired, please, reload the page/ =~ response.css("script").text
    if not logged_out.nil?
        rivals_id = Rails.application.credentials.dig :rivals, :id
        rivals_token = Rails.application.credentials.dig :rivals, :token
        rivals_hash = Rails.application.credentials.dig :rivals, :hash
      	request_to :login, url: "http://rivalregions.com/?viewer_id=#{rivals_id}&id=#{rivals_id}&access_token=#{rivals_token}&hash=#{rivals_hash}"
    end
    
    if url == "http://rivalregions.com/info/regions"
      self.regions(response, url, data)
    else
      request_to :regions, url: "http://rivalregions.com/info/regions"
    end
  end

  def go
    request_to :parse, url: "http://rivalregions.com/info/regions"
  end

end
