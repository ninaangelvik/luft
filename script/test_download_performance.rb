require 'net/http'
require 'uri'
require 'json'

times = []
fetch_uris = [
				"https://masteroppgave-177911.appspot.com/get_data?all=true",
				"https://masteroppgave-177911.appspot.com/get_data?hour=true",
				"https://masteroppgave-177911.appspot.com/get_data?day=true",
				"https://masteroppgave-177911.appspot.com/get_data?week=true",
				# "https://masteroppgave-177911.appspot.com/get_data?month=true"
				"https://masteroppgave-177911.appspot.com/get_data?hour=true&within=[69.698048, 18.849053,7]",
				"https://masteroppgave-177911.appspot.com/get_data?day=true&within=[69.698048, 18.849053,7]",
				"https://masteroppgave-177911.appspot.com/get_data?week=true&within=[69.698048, 18.849053,7]"
				# "https://masteroppgave-177911.appspot.com/get_data?month=true&within=[69.698048, 18.849053,7]",
				]

download_uris = [
				"https://masteroppgave-177911.appspot.com/download?all=true",
				"https://masteroppgave-177911.appspot.com/download?hour=true",
				"https://masteroppgave-177911.appspot.com/download?day=true",
				"https://masteroppgave-177911.appspot.com/download?week=true",
				# "https://masteroppgave-177911.appspot.com/download?month=true"
				"https://masteroppgave-177911.appspot.com/download?hour=true&within=[69.698048, 18.849053,7]",
				"https://masteroppgave-177911.appspot.com/download?day=true&within=[69.698048, 18.849053,7]",
				"https://masteroppgave-177911.appspot.com/download?week=true&within=[69.698048, 18.849053,7]"
				# "https://masteroppgave-177911.appspot.com/download?month=true&within=[69.698048, 18.849053,7]",
				]

puts "Latency test: fetching data"
fetch_uris.each do |u|
	uri = URI.parse(u)	
	puts "Fetching data from #{uri} 20 times"
	for i in 0...20
		start = Time.now
		response = Net::HTTP.get_response(uri)
		stop = Time.now
		times << (stop - start)
	end

	average = times.inject(0.0) { |sum, el| sum + el } / times.size
	puts "#{JSON.parse(response.body).count} elements found"
	puts "Average fetch time: #{average} seconds.\n"
end

puts "\nLatency test: downloading data"
download_uris.each do |u|
	uri = URI.parse(u)
	puts "Downloading data from #{uri} 20 times"
	for i in 0...20
		start = Time.now
		response = Net::HTTP.get_response(uri)
		stop = Time.now
		times << (stop - start)
	end

	average = times.inject(0.0) { |sum, el| sum + el } / times.size
	puts "#{response.body.split("\n").count} elements found."
	puts "Average download time: #{average} seconds.\n"
end