require 'rufus-scheduler'

namespace 'oneirros' do
  namespace 'spider' do
    namespace 'regions' do 
      desc "Parse Realtime Region Data into InfluxDB once"
      task :once => [:environment] do
        RegionsSpider.authed_parse!
      end

      desc "Start Parsing Region Data periodically"
      task :daemon => [:environment] do
        AuthedBulkWorker.new(RegionsSpider, '5m').join
      end

      desc "Bootstrap Region Data into ActiveRecord"
      task :bootstrap => [:environment] do
        RegionsBootstrapSpider.authed_parse!
      end
    end
  end
end
  
