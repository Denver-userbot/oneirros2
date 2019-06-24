require 'pp'

class CompanyBootstrapSpider < RivalRegionsAuthedSpider
  @engine = :mechanize

  def setup(owner_crawl_id, company_id) 
    company = OneirrosCompany.find(company_id)
    @company_id = company.id
    @owner_crawl_id = owner_crawl_id
  end

  def go
    auth unless @authed
    raise Exception("Can't login") unless @authed

    request_to :parse_factories, url: "http://rivalregions.com/factory/whose/#{@owner_crawl_id}"
  end

  def parse_factories(response, url:, data:{})
     response.css("#list_tbody tr.list_link").each do |row|
       cols = row.css("td")
       idcol = cols[0].attributes["action"].text
       id = idcol.split('/')[2] 

       infocol = cols[1]
       infocol.search('br').each do |n|
         n.replace('\n')
       end
       name = infocol.text.split('\n')[0].squish

       factory = RivalFactory.find_or_create_by(rivals_factory_id: id)
       factory.name = name 
 
       request_to :parse_one_factory, url: "http://rivalregions.com/listed/factory/#{id}", data: { factory: id }
     end
   end

   def parse_one_factory(response, url:, data:{})
      repsonse.css("#list_tbody tr.list_link").each do |row|
        cols = row.css("td")
        
        playerid = cols[1].attributes["action"].text.split('/')[2]
        playername = cols[2].text
        energy = cols[3].attributes["rat"].text.to_i
        # TODO Efficiency
      end
   end

  end

end
