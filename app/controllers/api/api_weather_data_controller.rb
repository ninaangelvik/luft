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
	  			csv << r
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
			records =	WeatherData.where("timestamp between ? and ?", from, to).pluck(:latitude, :longitude, :humidity, :temperature, :pm_ten, :pm_two_five, :timestamp, :area)
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
				area_recs << r if (Geocoder::Calculations.distance_between([latitude, longitude], [r[0], r[1]], :units=>:km) < radius)
			end
			records = area_recs
		elsif params[:area]
			area_recs = []
			records.each do |r|
				area_recs << r if r[-1] == params[:area]
			end
			records = area_recs
		end
		return true, records
	end
end