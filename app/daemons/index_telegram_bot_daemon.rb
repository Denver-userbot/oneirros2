require 'time'

require 'action_view'
include ActionView::Helpers::DateHelper

class IndexTelegramBotDaemon < TelegramBotDaemon
  def initialize
    @bot_token = Rails.application.credentials.dig(:telegram, :bots, :index_token)
  end

  def run 
    Telegram::Bot::Client.run(@bot_token) do |bot|
      bot.listen do |message|
	react = true
        if message.text.nil? or message.text.empty?
          # Sticker or other
        elsif (message.text == '/start' or message.text == 'help') and not message.chat.type == "group"
          bot.api.send_message(chat_id: message.chat.id, text: "Hello there ! Tell me what indice you want (med|edu|mil|dev) and the amount and i'll come back to you with the required building amount as per our last data. For example, send me 'mil 3' to get stats on Military 3.\n\nNote the data can be delayed by up to ten minutes. This bot is part of the Oneirros Project (http://oneirros.xyz:3000) and still in development. For any inquiries, please contact @EphyRaZy")
        else
          captures = message.text.match(/^\/?([[:alpha:]]+)[[:blank:]]*([[:digit:]]+)/)
          if (message.chat.type == "group") and message.text.match(/^\//).nil? 
            react = false
          end


          if captures.nil?
            bot.api.send_message(chat_id: message.chat.id, text: "Sorry, I didn't get that..") unless message.chat.type == "group"
          elsif react
  
            index = captures[1].downcase.slice(0, 3)
            level = captures[2].to_i

            # Detect relevant building
            case index
            when 'med', 'medi', 'medical'
              index = 'med'
              building = "hospital"
              display_building = "Hospitals"
              display_index = "Medical"
            when 'mil', 'mili', 'military', 'militaire'
              index = 'mil'
              building = "military_base"
              display_building = "Military Bases"
              display_index = "Military"
            when 'edu', 'education'
              index = 'edu'
              building = "school"
              display_building = "Schools"
              display_index = "Education"
            when 'dev', 'development', 'developement'
              index = 'dev'
              building = "housing_fund"
              display_building = "Housing Fund"
              display_index = "Development"
            end

            if building.nil?
               bot.api.send_message(chat_id: message.chat.id, text: "Sorry, I don't recognize that indice. Type /start for usage information.") unless message.chat.type == "group"
            elsif level < 1 or level > 10
               bot.api.send_message(chat_id: message.chat.id, text: "Please enter an indice level from 1 to 10. Type /start for usage information.")
	    else
               found = false
               # Query influx for data
               RivalRegionMetrics.all.select("#{index}_index", :rivals_id, "min(#{building})").where("#{index}_index = #{level} AND time > now() - 1h").time('5m').fill(:none).order(time: :desc).limit(3).each do |metric|
                 if not found 
                   found = true

                   if metric["min"].nil?
                     bot.api.send_message(chat_id: message.chat.id, text: "Sorry, something went wrong with the database query.\nThis is a known bug and we're looking into fixing it.\nTry again in a moment !")
                   else
                     dt = DateTime.parse(metric["time"])
                     timestring = distance_of_time_in_words(dt, DateTime.now, include_seconds: true)
                     bot.api.send_message(chat_id: message.chat.id, text: "According to my last data (#{timestring} ago):\nMinimum Amount for #{display_index} #{level} is #{metric["min"]} #{display_building}")
                     end
                   end
               end

               if not found
                 bot.api.send_message(chat_id: message.chat.id, text: "Sorry, no recent data found. This likely means background data process crashed. Try again later !")
               end
            end
          end

        end
      end

      if react or not message.chat.type == "group" 
        puts "[#{message.from.first_name}] @#{message.from.username} << #{message.text}"
      end
    end
  end
end
