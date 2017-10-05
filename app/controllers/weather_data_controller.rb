require 'csv'
class WeatherDataController < ApplicationController  
	include ActionView::Helpers::TextHelper

	def download
		filename, records = find_records(params)
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
		filename, records = find_records(params)

		
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
		if params[:all]
			records = WeatherData.all
	    filename = "records-all.csv"	
		elsif params[:fromtime] 
			from = params[:fromtime].to_time
			if params[:totime]
				to = params[:totime].to_time
			
				records =	WeatherData.where(:timestamp => from..to)
				filename = "records-custom-interval.csv"
			elsif params[:hours]
				records =	WeatherData.where(:timestamp => from..from + params[:hours].to_i.hour)
				filename = "records-#{pluralize(params[:hours], 'hour')}.csv"		
			elsif params[:weeks]
				records =	WeatherData.where(:timestamp => from..from + params[:weeks].to_i.week)
				filename = "records-#{pluralize(params[:weeks], 'week')}.csv"
			elsif params[:months]
				records =	WeatherData.where(:timestamp => from..from + params[:months].to_i.week)
				filename = "records-#{pluralize(params[:months], 'month')}.csv"
			else
				flash[:error] = "Objektet kan ikke finnes."
				redirect_to root_path
			end
		else
			flash[:error] = "Vennligst spesifiser hva du vil laste ned."
			redirect_to root_path
		end

		return filename, records
	end

end