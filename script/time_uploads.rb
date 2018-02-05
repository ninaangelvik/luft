require File.expand_path('../../config/environment',  __FILE__)

NUM_FILES = ARGV[1]

filename = ARGV[0]

file_count = 0

puts "Starting clock for #{filename} x #{NUM_FILES.to_i} "
start = Time.now

while file_count < NUM_FILES.to_i do 
	file_count = WeatherData.find_by_sql([ "SELECT DISTINCT(filename)
																					 FROM weather_data 
																					 WHERE filename 
																					 LIKE ?", "time_uploads_10080%"]).count
end 

stop = Time.now

puts "#{NUM_FILES} #{filename} uploaded in (#{((stop-start)/60).to_s} minutes)"