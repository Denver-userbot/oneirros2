namespace :oneirros do
  namespace :export do
    namespace :seeds do
      desc "Exports Region Static Data to Seeds File"
      task :regions => :environment do 
        puts '# ruby encoding: utf-8'
        RivalRegion.order(:id).all.each do |region| 
          puts "RivalRegion.create(#{region.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
        end
      end 
    end
  end
end
