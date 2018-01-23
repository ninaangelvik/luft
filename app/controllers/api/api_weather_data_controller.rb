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
	  	csv_string = CSV.generate do |csv|
	  		records.each do |r|
	  			csv << [r.longitude, r.latitude, r.humidity, r.temperature, r.pm_ten, r.pm_two_five, r.timestamp]
	  		end
			end
	  	self.response_body = csv_string
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
	  	from = from.in_time_zone

			to = params[:totime].to_time
	  	to = Time.parse(to.strftime('%Y-%m-%d %H:%M:%S UTC')).to_s
			to = to.in_time_zone
			records = WeatherData.find_by_sql([ "SELECT longitude, latitude, avg(humidity) AS humidity, avg(temperature) AS temperature, 
																					 avg(pm_ten) as pm_ten, avg(pm_two_five) as pm_two_five, area, timestamp 
																					 FROM weather_data GROUP BY longitude, latitude"])
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
				area_recs << r if (Geocoder::Calculations.distance_between([latitude, longitude], [r.latitude, r.longitude], :units=>:km) < radius)
			end
			records = area_recs
		elsif params[:area]
			area_recs = []
			records.each do |r|
				area_recs << r if r.area == params[:area]
			end
			records = area_recs
		end
		return true, records
	end
end