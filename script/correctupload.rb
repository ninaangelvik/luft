require 'csv' 
require File.expand_path('../../config/environment',  __FILE__)


begin 
  data = File.open(ENV["HOME"] + "/Downloads/DATA.CSV", 'r').read
  puts "Entering perform_later"
  csv_text = data.split("\n")

  csv_text = csv_text.reject{|line| line.include?("Time") || line.blank?}
 
  records = []
 
  radius = 8.0
  area_recs = []
  csv_text.each do |line|
    objects = []
    if line.include? (";")
      objects = line.split(";")
    elsif line.include? (",")        
      objects = line.split(",")
    end
    unless objects.empty?
      time = objects[0][0..18] + ".0Z"
      begin 
        r = WeatherData.new(timestamp: time.to_time, latitude: objects[1].to_f, longitude: objects[2].to_f, pm_ten: objects[3].to_f, pm_two_five: objects[4].to_f, humidity: objects[5].to_f, temperature: objects[6].to_f, filename: "hei")
      rescue => e
        puts e
        next
      end
      WeatherData::AREAS.each do |k, v| 
        if (Geocoder::Calculations.distance_between([v[0], v[1]], [r.latitude, r.longitude], :units=>:km) < 8)
          r.area = k
          break
        end
      end
      records << r   
      puts records.count
    end
  end
rescue => e
  puts "Something went wrong with file #{filename}. Error: #{e.to_s}"
end