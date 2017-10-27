require 'csv' 
require File.expand_path('../../config/environment',  __FILE__)



data = File.open(ENV["HOME"] + "/Documents/one_row.csv", 'r').read

csv_text = data.split("\n")
csv_text = csv_text.reject{|line| line.include?("Time") || line.blank?}

records = [] 
csv_text.each do |line|
  if line.include? (";")
    objects = line.split(";")
  elsif line.include? (",")        
    objects = line.split(",")
  end
  records << WeatherData.new(timestamp: objects[0].to_time, latitude: objects[1].to_f, longitude: objects[2].to_f, pm_ten: objects[3].to_f, pm_two_five: objects[4].to_f, humidity: objects[5].to_f, temperature: objects[6].to_f)
end

WeatherData.import records

