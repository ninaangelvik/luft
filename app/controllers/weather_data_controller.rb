require 'csv'
class WeatherDataController < ApplicationController  
	include ActionView::Helpers::TextHelper

	def download
		ret, filename, records = find_records(params)

		unless ret
			flash[:error] = "Søket er ugyldig."
			redirect_to root_path and return 
		end
		
		unless records.empty?
	  	CSV.open(Rails.root.join('tmp', filename), "wb") do |csv|
		    csv <<  ["Time",
		    				"Longitude",
		    				"Latitude",
		    				"PM10",
		    				"PM2.5",
		    				"Humidity",
		    				"Temperature"
		    				]
		    records.each do |r|
		      csv <<  [r.timestamp,
		      				r.longitude,
		      				r.latitude,
		      				r.pm_ten,
		      				r.pm_two_five,
		      				r.humidity,
		      				r.temperature
		      				]
			    end
	    end
    	send_file(Rails.root.join('tmp', filename), :filename => filename)
		else
			flash[:error] = "Fant ingen data innenfor det gitte intervallet"
			redirect_to root_path
		end
	end

	def get_data
		ret, filename, records = find_records(params)		

		unless ret
			flash[:error] = "Søket er ugyldig."
			redirect_to root_path and return 
		end

		unless records.empty?
			records_json = []
			records.each do |r| 
				records_json << r.as_json(only: [:latitude, :longitude, :humidity, :temperature, :pm_ten, :pm_two_five, :timestamp])
	  	end
	  	render json: records_json.to_json
		else
			flash[:error] = "Fant ingen data innenfor det gitte intervallet"
			redirect_to root_path
		end
	end

	private
	def find_records(params)
		case 
		when params[:all]
			records = WeatherData.all
	    filename = "records-all.csv"
	  when (params[:fromtime] and params[:totime])
			from = params[:fromtime].to_time
			to = params[:totime].to_time

			filename = "records-custom.csv"
		when params[:hour]
				from = Time.now.beginning_of_hour
				to = Time.now.end_of_hour
			
				filename = "records-hour.csv"	
		when params[:day]
				from = Time.now.beginning_of_day
				to = Time.now.end_of_day
			
				filename = "records-24-hours.csv"		
		when params[:week]
				from = Time.now.beginning_of_week
				to = Time.now.end_of_week

				filename = "records-week.csv"
		when params[:month]
				from = Time.now.beginning_of_month
				to = Time.now.end_of_month
				filename = "records-month.csv"
		else
			return false
		end 		
		
		records =	WeatherData.where(:timestamp => from..to) unless params[:all]

		if params[:within]
			within = params[:within][1...-1].split(",")
			
			if within.count > 3
				return false 
			else  
				latitude = within[0].to_f
				longitude = within[1].to_f
				radius = within[2].to_f
				area_recs = []

				records.each do |r|
					area_recs << r if (Geocoder::Calculations.distance_between([latitude, longitude], [r.latitude, r.longitude], :units=>:km) < radius)
				end
				records = area_recs
			end
		end
		pp records.count
		return true, filename, records
	end

end