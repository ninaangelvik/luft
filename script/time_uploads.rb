require File.expand_path('../../config/environment',  __FILE__)

NUM_FILES = ARGV[1]

filename = ARGV[0]

file_count = 0

puts "Starting clock for #{filename} x #{NUM_FILES.to_i} "
start = Time.now

while file_count < NUM_FILES.to_i do 
	sleep(3.seconds)
	file_count = WeatherData.uniq.pluck(:filename).count
end 

stop = Time.now

puts "#{NUM_FILES} #{filename} uploaded in (#{((stop-start)/60).to_s} minutes)"