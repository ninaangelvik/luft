require 'csv'
require 'active_support/core_ext/integer/time'


file = "#{ENV['HOME']}/Documents/google/google_test_file_#{ARGV[0]}_#{ARGV[1]}_3.csv"

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
		latitude = 69.650581	
		longitude = 18.94482
	when "bodo"
		latitude = "67.2915999"
		longitude = "14.4123474"
	when "harstad"
		latitude = "68.785187"
		longitude = "16.4478438"
	when "alta"
		latitude = "69.9664488"
		longitude = "23.2570952"
	when "kirkenes"
		latitude = "69.7241713"
		longitude = "30.0407674"	
	end

	pm_ten = "21"
	pm_two_five = "33.33"
	humidity =  "46"
	temperature = 0
	growing = false
	ARGV[1].to_i.times do |t|
		time = ((Time.now - 2.hours) + t*60).strftime "%d/%m/%Y %H:%M:%S"
		growing ? temperature += 1 : (temperature -= 1) 
		growing ? latitude += 0.001 : longitude += 0.001
		
		growing = !growing if (t % 30 == 0)
	
		csv <<  [	time,
						 	latitude.to_s,
							longitude.to_s,
							pm_ten,
							pm_two_five,
							humidity,
							temperature.to_s
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

