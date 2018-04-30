require 'net/http'
require 'uri'
require 'json'

times = []
fetch_uris = [
				#/api/data?totime=2018-04-29T11:39:48&fromtime=2018-04-22T11:39:48&within=68.7901066219617,16.51617647190406,1.9054457637927478&plotchart=true
				#/api/data?totime=2018-04-29T11:39:48&fromtime=2018-04-22T11:39:48&within=68.7901066219617,16.51617647190406,1.9054457637927478&plotchart=map



				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Lakselv&plotmap=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Lakselv&plotchart=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Tromsø&plotmap=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Tromsø&plotchart=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Bodø&plotmap=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Bodø&plotchart=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Alta&plotmap=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Alta&plotchart=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Harstad&plotmap=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Harstad&plotchart=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Mo i Rana&plotmap=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Mo i Rana&plotchart=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Narvik&plotmap=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Narvik&plotchart=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Nord-Troms&plotmap=true"),
				# URI.escape("https://luft-184208.appspot.com/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Nord-Troms&plotchart=true"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Lakselv"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Lakselv&plotmap=true"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Lakselv&plotchart=true"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Tromsø"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Tromsø&plotmap=true"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Tromsø&plotchart=true"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Bodø"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-01-01T07:55:28&area=Bodø"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Bodø&plotmap=true"),
				URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Bodø&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Alta"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Alta&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Alta&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Harstad"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Harstad&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Harstad&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Mo i Rana"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Mo i Rana&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Mo i Rana&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Narvik"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Narvik&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Narvik&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Nord-Troms"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Nord-Troms&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?totime=2018-04-02T06:55:28&fromtime=2018-03-02T07:55:28&area=Nord-Troms&plotchart=true"),


				# URI.escape("http://localhost:8080/api/data?all=true&area=Lakselv"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Lakselv&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Lakselv&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Tromsø"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Tromsø&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Tromsø&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Bodø"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Bodø&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Bodø&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Alta"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Alta&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Alta&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Harstad"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Harstad&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Harstad&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Mo i Rana"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Mo i Rana&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Mo i Rana&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Narvik"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Narvik&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Narvik&plotchart=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Nord-Troms"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Nord-Troms&plotmap=true"),
				# URI.escape("http://localhost:8080/api/data?all=true&area=Nord-Troms&plotchart=true"),
# download_uris = [
# 				"https://masteroppgave-177911.appspot.com/download?all=true",
# 				"https://masteroppgave-177911.appspot.com/download?hour=true",
# 				"https://masteroppgave-177911.appspot.com/download?day=true",
# 				"https://masteroppgave-177911.appspot.com/download?week=true",
# 				# "https://masteroppgave-177911.appspot.com/download?month=true"
# 				"https://masteroppgave-177911.appspot.com/download?hour=true&within=[69.698048, 18.849053,7]",
# 				"https://masteroppgave-177911.appspot.com/download?day=true&within=[69.698048, 18.849053,7]",
# 				"https://masteroppgave-177911.appspot.com/download?week=true&within=[69.698048, 18.849053,7]"
# 				# "https://masteroppgave-177911.appspot.com/download?month=true&within=[69.698048, 18.849053,7]",
				]

puts "Latency test: fetching data"
fetch_uris.each do |u|
	puts "Fetching data from #{u} 10 times"
	uri = URI.parse(u)
	response = ''
	times = []
	# Net::HTTP.start(uri.host, uri.port, :open_timeout => 10, :read_timeout => 200, :use_ssl => true) do |http|
	# 	for i in 0...10
	# 		start = Time.now
	# 		response = http.get(uri)
	# 		stop = Time.now
	# 		times << (stop - start)
	# 	end  
	# end
	for i in 0...5
		start = Time.now
		response = Net::HTTP.get_response(uri)
		stop = Time.now
		times << (stop - start)
	end
	average = times.inject(0.0) { |sum, el| sum + el } / times.size
	puts "Average fetch time: #{average} seconds.\n"
	puts response.body.length == 0 ? "0 elements found" : "#{JSON.parse(response.body).count} elements found" 
end

# puts "\nLatency test: downloading data"
# download_uris.each do |u|
# 	uri = URI.parse(u)
# 	puts "Downloading data from #{uri} 20 times"
# 	for i in 0...20
# 		start = Time.now
# 		response = Net::HTTP.get_response(uri)
# 		stop = Time.now
# 		times << (stop - start)
# 	end

# 	average = times.inject(0.0) { |sum, el| sum + el } / times.size
# 	puts "#{response.body.split("\n").count} elements found."
# 	puts "Average download time: #{average} seconds.\n"
# end