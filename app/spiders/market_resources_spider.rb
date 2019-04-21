class MarketResourcesSpider < RivalRegionsAuthedSpider
  @engine = :mechanize
  RESOURCE_LIST = [1, 2, 3, 4, 11, 15, 21, 24, 13, 20, 14, 16, 18, 22, 23]

  def parse_authed(response, url:, data: {}) 
    raise Exception("Don't use me this way")
  end 

  def parse_resource(response, url:, data: {})
    if self.authed_check(response)
      number_sent = 0
      response.css('#list_tbody tr.list_link').each do |list|
        rows = list.css('td')
        price = rows[3].attributes['rat'].text.to_i 
        return unless number_sent < 5
        number_sent += 1
        RivalResourceMetrics.write({ :rivals_resource_id => data[:resource], :lowest_market_price => price })
      end
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
