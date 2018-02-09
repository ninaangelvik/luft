require 'net/http'
require 'uri'
require 'json'

file = ARGV[0]
num_times = ARGV[1].to_i

# filename = File.basename(file)
uri = URI.parse("http://localhost:8000/lastopp")
# uri = URI.parse("http://luft-184208.appspot.com/api/upload")

file_content = File.read(file)

header = {"Content-Type": "application/json"}
file_content = {:Filename => file,
								:Fize => file_content.size,
								:ContentType => "text/csv",
								:Contents => file_content

	}

num_times.times do |x|
	# Create the HTTP objects
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Post.new(uri.request_uri, header)
	request.body = file_content.to_json
		
	puts "Ready for post"
	# Send the request
	response = http.request(request)
	puts "Response: #{response}"
end 