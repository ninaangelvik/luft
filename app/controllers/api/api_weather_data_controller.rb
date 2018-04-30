require 'csv'
require 'time'
class Api::ApiWeatherDataController < ApiController

		def get_data 
			ret, records = find_records(params)
			if ret == false 
				self.response_body = "400 Bad Request"
				return 
			end
			time_interval = 0
			unless records.empty?
				if params[:plotmap]
					records = aggregateMapData(records)
				elsif params[:plotchart]
					from = records.first.timestamp
					to = records.last.timestamp
					records = aggregateChartData(records, from, to)
					time_interval = ((to.to_time).minus_with_coercion(from.to_time)) / 3600
				end 
		  	self.response_body = WeatherDataSerializer.new(records, {params: {time_interval: time_interval}}).serialized_json
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
				records = WeatherData.where(["timestamp between ? and ?", "#{from}", "#{to}"]).select(:id, :longitude, :latitude, :pm_ten, :pm_two_five, :temperature, :humidity, :timestamp).order(:timestamp)
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
				records = records.within(radius, :origin => [latitude, longitude])
			elsif params[:area]
				area_recs = records.where(area: params[:area])
				records = area_recs
			end
			return true, records
		end

		def aggregateMapData(records)
			data = []
			records.group_by{|r| [r.latitude.round(4), r.longitude.round(4)]}.each do |key, value|
				num_values = value.count
				pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
				pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
				humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
				temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
        data << WeatherData.new(latitude: key[0].to_f, longitude: key[1].to_f, pm_ten: pm_ten.round(2), pm_two_five: pm_two_five.round(2), humidity: humidity.round(2), temperature: temperature.round(2), timestamp: nil)
			end
			return data
		end

		def aggregateChartData(records, from, to)
			duration = ((to.to_time).minus_with_coercion(from.to_time)) / 3600
			data = []
			
			#number of hours
			if duration <= 1 
				records.group_by{|r| r.timestamp.strftime('%FT%H:%M')}.each do |key, value|
					num_values = value.count
					pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
					pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
					humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
					temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
        	data << WeatherData.new(latitude: 0.0, longitude: 0.0, pm_ten: pm_ten.round(2), pm_two_five: pm_two_five.round(2), humidity: humidity.round(2), temperature: temperature.round(2), timestamp: key)
				end
			elsif duration <= 168
				records.group_by{|r| r.timestamp.strftime('%F %H')}.each do |key, value|
					num_values = value.count
					pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
					pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
					humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
					temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
					r = WeatherData.new(latitude: 0.0, longitude: 0.0, pm_ten: pm_ten.round(2), pm_two_five: pm_two_five.round(2), humidity: humidity.round(2), temperature: temperature.round(2), timestamp: key.to_time)
					data << r
				end
			elsif duration <= 744
				records.group_by{|r| r.timestamp.strftime('%F')}.each do |key, value|
					num_values = value.count
					pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
					pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
					humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
					temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
        	r = WeatherData.new(latitude: 0.0, longitude: 0.0, pm_ten: pm_ten.round(2), pm_two_five: pm_two_five.round(2), humidity: humidity.round(2), temperature: temperature.round(2), timestamp: key.to_time)
					data << r
				end
			else 
				records.group_by{|r| r.timestamp.strftime('%Y-%m')}.each do |key, value|
					num_values = value.count
					pm_ten = value.collect {|v| v.pm_ten}.reduce(:+)/num_values
					pm_two_five = value.collect {|v| v.pm_two_five}.reduce(:+)/num_values
					humidity = value.collect {|v| v.humidity}.reduce(:+)/num_values
					temperature = value.collect {|v| v.temperature}.reduce(:+)/num_values
        	data << WeatherData.new(latitude: 0.0, longitude: 0.0, pm_ten: pm_ten.round(2), pm_two_five: pm_two_five.round(2), humidity: humidity.round(2), temperature: temperature.round(2), timestamp: key)
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