require File.expand_path('../../config/environment',  __FILE__)

file_sizes = {"0-99" => 0, "100-199" => 0, "200-299" => 0,"300-399" => 0, "400-499" => 0, "500-599" => 0, "600-699" => 0, "700-799" => 0, "800-899" => 0, "900-999" => 0, "1000-1099" => 0, "1100-1199" => 0, "> 1200" => 0}	

file_names =  WeatherData.all.collect{|m| m.filename}.uniq!
files = []
file_names.each do |fn|
	file = Datafile.where(filename: fn).first
	if file.nil?
		puts fn
		next
	end
 
	case (file.size.to_f/1024.to_f).round(2)
	when 0..99.99 then file_sizes["0-99"] += 1 
	when 100..199.99 then file_sizes["100-199"] += 1
	when 200..299.99 then file_sizes["200-299"] += 1
	when 300..399.99 then file_sizes["300-399"] += 1
	when 400..499.99 then file_sizes["400-499"] += 1
	when 500..599.99 then file_sizes["500-599"] += 1
	when 600..699.99 then file_sizes["600-699"] += 1
	when 700..799.99 then file_sizes["700-799"] += 1
	when 800..899.99 then file_sizes["800-899"] += 1
	when 900..999.99 then file_sizes["900-999"] += 1
	when 1000..1099.99 then file_sizes["1000-1099"] += 1
	when 1100..1199.99 then file_sizes["1100-1199"] += 1
	else
		puts (file.size.to_f/1024.to_f).round(2).to_s
		file_sizes["> 1200"] += 1
	end
end
puts file_sizes
