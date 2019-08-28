require 'kimurai'
require 'pp'

class RegionsSpider < RivalRegionsAuthedSpider
  @engine = :mechanize
  @authed_url = "http://rivalregions.com/info/regions"

  def parse_authed(response, url:, data: {})

    super(response, url: url, data: data)

  en_map = {
        "Region" => "name",
        "AUTO" => "is_autonomy",
        "+" => true,
        "-" => false,
        "POP" => "citizens",
        "RES" => "residents",
        "DAM ATA" => "initial_atk",
        "DAM DEF" => "initial_def",
        "HO" => "hospital",
        "MB" => "military_base",
        "SC" => "school",
        "MS" => "missile",
        "PO" => "port",
        "PP" => "power_plant",
        "SP" => "spaceport",
        "AE/RS" => "airport",
        "HF" => "housing_fund",
        "GOL" => "gold_now",
        "OIL" => "oil_now",
        "ORE" => "ore_now",
        "URA" => "ura_now",
        "DIA" => "dia_now",
        "GOL R" => "gold_base",
        "OIL R" => "oil_base",
        "ORE R" => "ore_base",
        "URA R" => "ura_base",
        "DIA R" => "dia_base",
        "GOL D" => "gold_max",
        "OIL D" => "oil_max",
        "ORE D" => "ore_max",
        "URA D" => "ura_max",
        "DIA D" => "dia_max",
        "IND EDU" => "edu_index",
        "IND MIL" => "mil_index",
        "IND HEA" => "med_index",
        "IND DEV" => "dev_index"
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
        colname = en_map[header.next]
        colval = col.text.squish
        if colname == "is_autonomy"
          rowhash[colname] = en_map[colval]
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

    return response
  end 

end
