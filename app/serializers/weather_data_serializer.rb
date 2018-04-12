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
 
  puts options
  attribute :timestamp do |object|
  	object.timestamp.nil? ? "" : object.timestamp.to_s
  end
end
