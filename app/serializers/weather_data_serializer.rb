class WeatherDataSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel
  attribute :latitude do |object|
  	object.latitude.to_f
  end

  attribute :longitude do |object|
  	object.longitude.to_f
  end

  attributes :humidity, :temperature, :pm_ten, :pm_two_five
 
  attribute :timestamp do |object, params|
  	if object.timestamp.nil?
  		object.timestamp = ""
  	elsif params[:time_interval] == 0
  		object.timestamp.to_s
  	else
	  	case params[:time_interval]
	  	when 0..1 then object.timestamp.strftime('%FT%H:%M')
	  	when 1..168 then object.timestamp.strftime('%F %H')
	  	when 168..744 then object.timestamp.strftime('%F')
	  	else
	  		object.timestamp.strftime('%Y-%m')
			end
		end
  end
end
