require 'rufus-scheduler'

namespace 'oneirros' do
  namespace 'spider' do
    namespace 'market' do 
      desc "Start Parsing Market Data periodically"
      task :daemon => [:environment] do
        AuthedBulkWorker.new(MarketResourcesSpider, '1m').join
      end
    end
  end
end
  
