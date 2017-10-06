require 'csv'

file = "#{ENV['HOME']}/Documents/google/google_test_file_#{ARGV[0]}_#{ARGV[1]}.csv"

CSV.open(file, 'w+') do |csv|
	csv <<  [ 
						"Time",
						"Latitude",
						"Longitude",
						"PM10",
						"PM2.5",
						"Humidity",
						"Temperature"
					]
	case ARGV[0]
	when "tromso"
		latitude = "69.650581"	
		longitude = "18.94482"
	when "bodo"
		latitude = "67.2915999"
		longitude = "14.4123474"
	end

	pm_ten = "21"
	pm_two_five = "33.33"
	humidity =  "46"
	temperature = "12"

	ARGV[1].to_i.times do |t|
		time = (Time.now + t*60).strftime "%d/%m/%Y %H:%M:%S"
		csv <<  [	time,
						 	latitude,
							longitude,
							pm_ten,
							pm_two_five,
							humidity,
							temperature
						]
		# csv <<  [	time,
		# 				  latitude_bodo,
		# 				  longitude_bodo,
		# 				  pm_ten,
		# 				  pm_two_five,
		# 				  humidity,
		# 				  temperature
		# 				]
	end	
end

