namespace 'oneirros' do
  namespace 'dev' do
    namespace 'companies' do
      desc "Create Test Company"
      task :create => [:environment] do 
        OneirrosCompany.create({name: "Test Company"})
      end
    end
  end
end

namespace "oneirros" do 
  namespace "spider" do 
    namespace "companies" do
       desc "Dev Bootstrap test"
       task :bootstrap, [:id, :crawl_owner_id] => [:environment] do |task, args|
         spider = CompanyBootstrapSpider.new
         spider.setup(args[:crawl_owner_id], args[:id])
         spider.go
       end
    end
  end
end
