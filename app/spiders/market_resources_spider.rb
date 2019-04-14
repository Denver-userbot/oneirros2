require 'pp'

class MarketResourcesSpider < RivalRegionsAuthedSpider
  @engine = :mechanize
  RESOURCE_LIST = [1, 2, 3, 4, 11, 15, 21, 24, 13, 20, 14, 16, 18, 22, 23]

  def parse_authed(response, url:, data: {}) 
    raise Exception("Don't use me this way")
  end 

  def parse_resource(response, url:, data: {})
    response.css('span .storage_buy_summ').each do |span|
      price = span.text.squish.tr('.', '').to_i
      RivalResourceMetrics.write({ :rivals_resource_id => data[:resource], :lowest_market_price => price })
    end
  end

  # Override for roundrobin behavious
  def go
    auth unless @authed
    raise Exception("Can't login to RR") unless @authed
    @resourcei = RESOURCE_LIST.to_enum unless not @resourcei.nil?

    begin
      resource = @resourcei.next
    rescue StopIteration => e
      @resourcei = RESOURCE_LIST.to_enum
      resource = @resourcei.next
    end

    request_to :parse_resource, url: "http://rivalregions.com/storage/listed/#{resource}", data: { :resource => resource }
  end

end  
