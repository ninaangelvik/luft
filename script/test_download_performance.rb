require 'net/http'
require 'uri'
require 'json'

times = []
within_uris = [
	URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-29T11:39:48&fromtime=2018-03-01T11:39:48within=69.6747430330008,18.94003089717284,5.838591143813072&plotchart=true"),
	URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-29T11:39:48&fromtime=2018-03-01T11:39:48&within=69.6747430330008,18.94003089717284,5.838591143813072&plotchart=map"),
	URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-29T11:39:48&fromtime=2018-03-01T11:39:48&within=69.6747430330008,18.94003089717284,5.838591143813072")	
]
area_uris = [
	URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-29T11:39:48&fromtime=2018-03-01T11:39:48&area=Tromsø&plotchart=true"),
	URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-29T11:39:48&fromtime=2018-03-01T11:39:48&area=Tromsø&plotchart=map"),
	URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-29T11:39:48&fromtime=2018-03-01T11:39:48&area=Tromsø")
]

puts "Latency test: aggregating 50000 records with coordinates"
within_uris.each do |u|
	puts "Aggregating data from #{u} 20 times"
	uri = URI.parse(u)
	response = ''
	times = []
	Net::HTTP.start(uri.host, uri.port, :open_timeout => 10, :read_timeout => 200, :use_ssl => true) do |http|
		for i in 0...20
			start = Time.now
			response = http.get(uri)
			stop = Time.now
			times << (stop - start)
		end  
	end
	average = times.inject(0.0) { |sum, el| sum + el } / times.size
	puts "Average time aggregating 50000 records with coordinates: #{average} seconds.\n"
	puts response.body.length == 0 ? "0 elements found" : "#{JSON.parse(response.body).count} elements found" 
end

puts "Latency test: aggregating 50000 records with area"
area_uris.each do |u|
	puts "Aggregating data from #{u} 20 times"
	uri = URI.parse(u)
	response = ''
	times = []
	Net::HTTP.start(uri.host, uri.port, :open_timeout => 10, :read_timeout => 200, :use_ssl => true) do |http|
		for i in 0...20
			start = Time.now
			response = http.get(uri)
			stop = Time.now
			times << (stop - start)
		end  
	end
	average = times.inject(0.0) { |sum, el| sum + el } / times.size
	puts "Average time aggregating 50000 records with area: #{average} seconds.\n"
	puts response.body.length == 0 ? "0 elements found" : "#{JSON.parse(response.body).count} elements found" 
end