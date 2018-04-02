require 'csv'
require 'time'
class Api::ApiWeatherDataController < ApiController

	def get_data 
		ret, records = find_records(params)	
		if ret == false 
			self.response_body = "400 Bad Request"
			return 
		end
		unless records.empty?
			if params[:plotmap]
				data_json = aggregateMapData(records)
			elsif params[:plotchart]
				data_json = aggregateChartData(records, params[:fromtime], params[:totime])
			else 
		  	data_json = []
		  	records.each do |r|
		  		data_json << {'Latitude' => r.latitude.to_s.to_f, 'Longitude' => r.longitude.to_s.to_f, 'Humidity' => r.humidity, 'Temperature' => r.temperature, 'PmTen' => r.pm_ten, 'PmTwoFive' => r.pm_two_five, 'Date' => r.timestamp.utc.to_s}
				end
			end
	  	self.response_body = data_json.to_json
	  else
	  	self.response_body = ""
	  end

	end

	def find_records(params)
		case 
		when params[:all]
			records = WeatherData.all.pluck(:latitude, :longitude, :humidity, :temperature, :pm_ten, :pm_two_five, :timestamp)
	 		return true, records
	  when (params[:fromtime] and params[:totime])
	  	from = params[:fromtime].to_time
	  	from = Time.parse(from.strftime('%Y-%m-%d %H:%M:%S UTC')).to_s
	  	from = from.in_time_zone('Copenhagen')

			to = params[:totime].to_time
	  	to = Time.parse(to.strftime('%Y-%m-%d %H:%M:%S UTC')).to_s
			to = to.in_time_zone('Copenhagen')

			time_span = (to.to_date - from.to_date).to_i

			records = WeatherData.where(["timestamp between ? and ?", "#{from}", "#{to}"]).order(:timestamp)
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
			area_recs = []
			records.each do |r|
				area_recs << r if Geocoder::Calculations.distance_between([latitude, longitude], [r.latitude, r.longitude], :units=>:km) < radius
			end
			records = area_recs
		elsif params[:area]
			area_recs = records.where(area: params[:area])
			records = area_recs
		end


		return true, records
	end

	def aggregateMapData(records)
		data = []
		records.group_by{|r| [r.latitude.round(4), r.longitude.round(4)]}.each do |key, value|
			pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/value.count
			pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/value.count
			humidity = value.collect {|v| v.humidity}.reduce(:+)/value.count
			temperature = value.collect {|v| v.temperature}.reduce(:+)/value.count
			data << {'Latitude' => key[0].to_s.to_f, 'Longitude' => key[1].to_s.to_f, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => ""}
		end
		return data
	end

	def aggregateChartData(records, from, to)
		duration = ((to.to_time).minus_with_coercion(from.to_time)) / 3600
		data = []
		#number of hours
		if duration <= 1 
			records.group_by{|r| r.timestamp.strftime('%FT%H:%M')}.each do |key, value|
				pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/value.count
				pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/value.count
				humidity = value.collect {|v| v.humidity}.reduce(:+)/value.count
				temperature = value.collect {|v| v.temperature}.reduce(:+)/value.count
				data << {'Latitude' => 0.0, 'Longitude' => 0.0, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => key}
			end
		elsif duration <= 24
			records.group_by{|r| r.timestamp.strftime('%FT%H')}.each do |key, value|
				pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/value.count
				pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/value.count
				humidity = value.collect {|v| v.humidity}.reduce(:+)/value.count
				temperature = value.collect {|v| v.temperature}.reduce(:+)/value.count
				data << {'Latitude' => 0.0, 'Longitude' => 0.0, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => key}
			end
		elsif duration <= 744
			records.group_by{|r| r.timestamp.strftime('%F')}.each do |key, value|
				pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/value.count
				pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/value.count
				humidity = value.collect {|v| v.humidity}.reduce(:+)/value.count
				temperature = value.collect {|v| v.temperature}.reduce(:+)/value.count
				data << {'Latitude' => 0.0, 'Longitude' => 0.0, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => key}
			end
		else 
			records.group_by{|r| r.timestamp.strftime('%Y-%m')}.each do |key, value|
				pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/value.count
				pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/value.count
				humidity = value.collect {|v| v.humidity}.reduce(:+)/value.count
				temperature = value.collect {|v| v.temperature}.reduce(:+)/value.count
				data << {'Latitude' => 0.0, 'Longitude' => 0.0, 'PmTen' => pm_ten.round(2), 'PmTwoFive' => pm_two_five.round(2), 'Humidity' => humidity.round(2), 'Temperature' => temperature.round(2), 'Date' => key}
			end
		end
		return data
	end
end