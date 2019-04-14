namespace 'oneirros' do
  namespace 'bots' do 
    namespace 'telegram' do
      desc "Index Telegram Bot"
      task :index => [:environment] do 
        IndexTelegramBotDaemon.new.run
      end
    end
  end
end
        
