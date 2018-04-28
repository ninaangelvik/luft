require File.expand_path('../../config/environment',  __FILE__)
sizes = {"0-99" => 0, "100-199" => 0, "200-299" => 0, "300-399" => 0, "400-499" => 0, "500-" => 0}

filenames = WeatherData.all.collect{|m| m.filename}.uniq!
filenames.each do |fn|
	file = Datafile.where(filename: fn).first
	next if file.nil?
	case (file.size.to_f/1024.to_f).round(2)
	when 0..99 then
		sizes["0-99"] += 1
	when 100..199 then
		sizes["100-199"] += 1
	when 200..299 then
		sizes["200-299"] += 1
	when 300..399 then
		sizes["300-399"] += 1
	when 400..499 then
		sizes["400-499"] += 1
	else
		sizes["500-"] += 1
	end
end

puts sizes