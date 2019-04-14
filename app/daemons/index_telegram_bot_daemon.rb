require 'pp'

class IndexTelegramBotDaemon < TelegramBotDaemon
  def initialize
    @bot_token = Rails.application.credentials.dig(:telegram, :bots, :index_token)
  end

  def run 
    Telegram::Bot::Client.run(@bot_token) do |bot|
      bot.listen do |message|
        if message.text == '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hello there ! Tell me what indice you want (med|edu|mil|dev) and the amount and i'll come back to you with the required building amount as per our last data. For example, send me 'mil 3' to get stats on Military 3.")
        else
          index = message.text.split(' ').first
          level = message.text.split(' ').last.to_i
          # Detect relevant building
          case index
          when 'med'
            building = "hospital"  
          when 'mil'
            building = "military_base"
          when 'edu'
            building = "school"
          when 'dev'
            building = "housing_fund"
          end

          if building.nil? 
             bot.api.send_message(chat_id: message.chat.id, text: "Sorry, I don't recognize that indice.")
	  else
             # Query influx for data
             RivalRegionMetrics.all.select("#{index}_index", :rivals_id, "min(#{building})").where("#{index}_index = #{level}").order(time: :desc).limit(1).each do |metric|
               bot.api.send_message(chat_id: message.chat.id, text: "According to my last data (#{metric["time"]}):\nMinimum Amount for #{index} #{level} is #{metric["min"]} #{building}")
             end
          end

        end
      end
    end
  end
end
