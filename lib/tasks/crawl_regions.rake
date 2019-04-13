require 'rufus-scheduler'

namespace 'oneirros' do
  namespace 'spider' do
    namespace 'regions' do 
      desc "Crawl Realtime Region Data into InfluxDB once"
      task :once => [:environment] do
        RegionsSpider.crawl!
      end

      desc "Start Crawling Region Data periodically"
      task :daemon => [:environment] do
        sched = Rufus::Scheduler.new
        spider = RegionsSpider.new
        scheduler.every '5m' do 
          spider.go
        end
        sched.join
      end

      desc "Bootstrap Region Data into ActiveRecord"
      task :bootstrap => [:environment] do
        RegionsBootstrapSpider.authed_parse!
      end
    end
  end
end
  
