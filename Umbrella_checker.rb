require "http"
require "json"

puts "I will tell you if you need an umbrella!"
puts "Where are you right now?"
user_location = gets.chomp

user_location = user_location.gsub(" ", "%20")

gmaps_key = ENV.fetch("GMAPS_KEY")


pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

gmaps_fetch = HTTP.get(gmaps_url)

gmaps_parse = JSON.parse(gmaps_fetch)

gmaps_results = gmaps_parse.fetch("results")

gmaps_detail = gmaps_results.at(0)

gmaps_geo = gmaps_detail.fetch("geometry")

gmaps_location = gmaps_geo.fetch("location")

gmaps_lat = gmaps_location.fetch("lat")

gmaps_lng = gmaps_location.fetch("lng")

puts gmaps_lat, gmaps_lng

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{gmaps_lat},#{gmaps_lng}"

pirate_weather_fetch = HTTP.get(pirate_weather_url)

pirate_weather_parse = JSON.parse(pirate_weather_fetch)

pirate_weather_currently = pirate_weather_parse.fetch("currently")

pirate_weather_hourly = pirate_weather_parse.fetch("hourly")

pirate_weather_hourly_summary = pirate_weather_hourly.fetch("summary")


pirate_weather_temperature = pirate_weather_currently.fetch("temperature")

puts pirate_weather_hourly_summary
puts pirate_weather_temperature.to_s + " degrees"

pirate_weather_hourly_data = pirate_weather_hourly.fetch("data")
rain = false
(0...12).each do |hour|
  
  if pirate_weather_hourly_data.at(hour).fetch("precipProbability") >= 0.1
    puts "In #{hour} hours the precipitation probability will be #{pirate_weather_hourly_data.at(hour).fetch("precipProbability")}"
    puts "You might want to carry an umbrella today."
    rain = true
    break
  end


end

if rain == false
  puts "You don't need an umbrella today."
end
