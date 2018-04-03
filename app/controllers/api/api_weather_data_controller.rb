require 'csv'
require 'time'
class Api::ApiWeatherDataController < ApiController

		def get_data 
			# start1 = Time.now
			ret, records = find_records(params)
			# stop1 = Time.now
			# puts "Time spent fetching #{records.length.to_s} records: #{(stop1-start1).to_s}"
			if ret == false 
				self.response_body = "400 Bad Request"
				return 
			end
			unless records.empty?
				if params[:plotmap]
					# start2 = Time.now
					data_json = aggregateMapData(records)
					# stop2 = Time.now
					# puts "Time spent aggregating map records: #{(stop2-start2).to_s}"
				elsif params[:plotchart]
					# start3 = Time.now
					# data_json = aggregateChartData(records, params[:fromtime], params[:totime])
					data_json = aggregateChartData(records, records.first.timestamp, records.last.timestamp)
					# stop3 = Time.now
					# puts "Time spent aggregating chart records: #{(stop3-start3).to_s}"
				else 
					# start4 = Time.now
			  	data_json = []
			  	records.each do |r|
			  		data_json << {'Latitude' => r.latitude.to_f, 'Longitude' => r.longitude.to_f, 'Humidity' => r.humidity, 'Temperature' => r.temperature, 'PmTen' => r.pm_ten, 'PmTwoFive' => r.pm_two_five, 'Date' => r.timestamp.utc.to_s}
					end
					# stop4 = Time.now
					# puts "Time spent converting to json: #{(stop4-start4).to_s}"
				end
		  	self.response_body = data_json.to_json
		  else
		  	self.response_body = ""
		  end
		end
		
		def find_records(params)
			case 
			when params[:all]
				records = WeatherData.all.select(:longitude, :latitude, :pm_ten, :pm_two_five, :temperature, :humidity, :timestamp).order(:timestamp)
		  when (params[:fromtime] and params[:totime])
		  	from = params[:fromtime].to_time
		  	from = Time.parse(from.strftime('%Y-%m-%d %H:%M:%S UTC')).to_s
		  	from = from.in_time_zone('Copenhagen')

				to = params[:totime].to_time
		  	to = Time.parse(to.strftime('%Y-%m-%d %H:%M:%S UTC')).to_s
				to = to.in_time_zone('Copenhagen')

				time_span = (to.to_date - from.to_date).to_i
				records = WeatherData.where(["timestamp between ? and ?", "#{from}", "#{to}"]).select(:longitude, :latitude, :pm_ten, :pm_two_five, :temperature, :humidity, :timestamp).order(:timestamp)
				# records = WeatherData.where(["timestamp between ? and ?", "#{from}", "#{to}"]).order(:timestamp)
			else
				return false, nil
			end
			if params[:within]
				within = params[:within].split(",")
				if within.count < 3
					return false, []
				end
				latitude = within[0].to_f
				longitude = within[1].to_f
				radius = within[2].to_f
				# start6 = Time.now
				records = records.within(radius, :origin => [latitude, longitude])
				# stop6 = Time.now()
				# puts "time calculating distance for #{records.length.to_s} records: #{(stop6-start6).to_s}"
			elsif params[:area]
				area_recs = records.where(area: params[:area])
				records = area_recs
			end
			return true, records
		end

		def aggregateMapData(records)
			data = []
			# num_records = records.length
			# if num_records.between?(500, 1000)
			# 	records = sample_data(records, num_records, 200) 
			# elsif num_records.between?(1000, 5000)
			# 	records = sample_data(records, num_records, 500) 
			# elsif num_records > 5000
			# 	records = sample_data(records, num_records, 1000) 
			# end
			records.group_by{|r| [r.latitude.round(4), r.longitude.round(4)]}.each do |key, value|
				num_values = value.count
				pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
				pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
				humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
				temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
				data << {'Latitude' => key[0].to_f, 'Longitude' => key[1].to_f, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => ""}
			end
			return data
		end

		def aggregateChartData(records, from, to)
			duration = ((to.to_time).minus_with_coercion(from.to_time)) / 3600
			data = []
			# num_records = records.length
			# if num_records.between?(500, 1000)
			# 	records = sample_data(records, num_records, 500) 
			# elsif num_records.between?(1000, 5000)
			# 	records = sample_data(records, num_records, 1000) 
			# elsif num_records > 5000
			# 	records = sample_data(records, num_records, 5000) 
			# end
			
			#number of hours
			if duration <= 1 
				records.group_by{|r| r.timestamp.strftime('%FT%H:%M')}.each do |key, value|
					num_values = value.count
					pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
					pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
					humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
					temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
					data << {'Latitude' => 0.0, 'Longitude' => 0.0, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => key}
				end
			elsif duration <= 24
				records.group_by{|r| r.timestamp.strftime('%FT%H')}.each do |key, value|
					num_values = value.count
					pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
					pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
					humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
					temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
					data << {'Latitude' => 0.0, 'Longitude' => 0.0, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => key}
				end
			elsif duration <= 744
				records.group_by{|r| r.timestamp.strftime('%F')}.each do |key, value|
					num_values = value.count
					pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
					pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
					humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
					temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
					data << {'Latitude' => 0.0, 'Longitude' => 0.0, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => key}
				end
			else 
				records.group_by{|r| r.timestamp.strftime('%Y-%m')}.each do |key, value|
					num_values = value.count
					pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
					pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
					humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
					temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
					data << {'Latitude' => 0.0, 'Longitude' => 0.0, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => key}
				end
			end
			return data
		end

		def sample_data(records, num_records, num_selection)
			generated_numbers = num_selection.times.map{Random.rand(num_records)}.sort!
			selected_recs = []
			generated_numbers.each do |n|
				selected_recs << records[n]
			end
			return selected_recs
		end
end