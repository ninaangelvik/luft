class ProcessInputJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    begin 
      start = Time.now
      Rails.logger.info "Entering perform_later"
      puts "Entering perform_later"
      csv_text = data.split("\n")

      csv_text = csv_text.reject{|line| line.include?("Time") || line.blank?}
     
      records = []
     
      radius = 8.0
      area_recs = []

      csv_text.each do |line|
        if line.include? (";")
          objects = line.split(";")
        elsif line.include? (",")        
          objects = line.split(",")
        end

        unless objects.empty?
          r = WeatherData.new(timestamp: objects[0].to_time, latitude: objects[1].to_f, longitude: objects[2].to_f, pm_ten: objects[3].to_f, pm_two_five: objects[4].to_f, humidity: objects[5].to_f, temperature: objects[6].to_f)
          WeatherData::AREAS.each do |k, v| 
            if (Geocoder::Calculations.distance_between([v[0], v[1]], [r.latitude, r.longitude], :units=>:km) < 8)
              r.area = k
              break
            end
          end
          records << r   
        end
      end

      Rails.logger.info "Records are ready"
      puts "Records are ready"

      WeatherData.import records unless records.empty?

      Rails.logger.info "Records are imported"
      puts "Records are imported"

      stop = Time.now
      Rails.logger.info "Done processing"
      Rails.logger.info "Time spent in total: #{stop - start}"
      puts "Time spent in total: #{stop - start}"
      return true
    rescue => e
      Rails.logger.error "Something went wrong #{e.to_s}"
      puts "Something went wrong #{e.to_s}"
      return e
    end
  end
end
