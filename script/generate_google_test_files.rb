require 'csv'

file = "#{ENV['HOME']}/Documents/google_test_file.csv"

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
	latitude_tromso = "69.650581"	
	longitude_tromso = "18.94482"
	latitude_bodo = "67.2915999"
	longitude_bodo = "14.4123474"
	pm_ten = "21"
	pm_two_five = "33.33"
	humidity =  "46"
	temperature = "12"

	10.times do |t|
		time = (Time.now + t*60).strftime "%d/%m/%Y %H:%M:%S"
		csv <<  [	time,
						 	latitude_tromso,
							longitude_tromso,
							pm_ten,
							pm_two_five,
							humidity,
							temperature
						]
		csv <<  [	time,
						  latitude_bodo,
						  longitude_bodo,
						  pm_ten,
						  pm_two_five,
						  humidity,
						  temperature
						]
	end
	
end

