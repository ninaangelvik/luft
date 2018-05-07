require 'net/http'
require 'uri'
require 'json'

times = []
within_uris = [
	URI.escape("http://airbit.uit.no/student?to=2018-04-29T11:39:48.000Z&from=2018-03-01T11:39:48.000Z&within=69.6747430330008,18.94003089717284,5.838591143813072&plotchart=true"),
	URI.escape("http://airbit.uit.no/studentaqis?to=2018-04-29T11:39:48.000Z&from=2018-03-01T11:39:48.000Z&within=69.6747430330008,18.94003089717284,5.838591143813072&plotmap=true"),
	URI.escape("http://airbit.uit.no/student?to=2018-04-29T11:39:48.000Z&from=2018-03-01T11:39:48.000Z&within=69.6747430330008,18.94003089717284,5.838591143813072")	
]
area_uris = [
	URI.escape("http://airbit.uit.no/student?to=2018-04-29T11:39:48.000Z&from=2018-03-01T11:39:48.000Z&area=Tromsø&plotchart=true"),
	URI.escape("http://airbit.uit.no/studentaqis?to=2018-04-29T11:39:48.000Z&from=2018-03-01T11:39:48.000Z&area=Tromsø&plotmap=true"),
	URI.escape("http://airbit.uit.no/student?to=2018-04-29T11:39:48.000Z&from=2018-03-01T11:39:48.000Z&area=Tromsø")
]

puts "Latency test: aggregating 50000 records with coordinates"
within_uris.each do |u|
	puts "Aggregating data from #{u} 20 times"
	uri = URI.parse(u)
	response = ''
	times = []
	Net::HTTP.start(uri.host, uri.port, :open_timeout => 10, :read_timeout => 200) do |http|
		for i in 0...20
			start = Time.now
			response = http.get(uri)
			stop = Time.now
			times << (stop - start)
		end  
	end
	average = times.inject(0.0) { |sum, el| sum + el } / times.size
	puts "Average time aggregating 50000 records with coordinates: #{average} seconds.\n"
end

puts "Latency test: aggregating 50000 records with area"
area_uris.each do |u|
	puts "Aggregating data from #{u} 20 times"
	uri = URI.parse(u)
	response = ''
	times = []
	Net::HTTP.start(uri.host, uri.port, :open_timeout => 10, :read_timeout => 200) do |http|
		for i in 0...20
			start = Time.now
			response = http.get(uri)
			stop = Time.now
			times << (stop - start)
		end  
	end
	average = times.inject(0.0) { |sum, el| sum + el } / times.size
	puts "Average time aggregating 50000 records with area: #{average} seconds.\n"
end