class ProcessInputJob < ApplicationJob
  queue_as :default

  def perform(filename)
    begin 
      if WeatherData.where(filename: "#{filename}").exists?
        puts "Records from #{filename} already exists in the database."
        return
      end 

      file = StorageBucket.files.get(filename)
      
      puts filename 
      i = 0
      while file.nil?
        if i == 30
          puts "Kunne ikke finne fil: #{filename}"
          return 
        end
        file = StorageBucket.files.get(filename)
        i += 1
      end

      data = file.body
      puts "Entering perform_later"
      csv_text = data.split("\n")

      csv_text = csv_text.reject{|line| line.include?("Time") || line.blank?}
     
      records = []
     
      radius = 8.0
      area_recs = []
      csv_text.each do |line|
        objects = []
        if line.include? (";")
          objects = line.split(";")
        elsif line.include? (",")        
          objects = line.split(",")
        end
        unless objects.empty? or objects.count != 7
          begin 
            time = objects[0][0..18] + ".0Z"
            time = time.to_time
          rescue ArgumentError 
            next
          end

          if validate_location(objects[1].to_f, objects[2].to_f) == false
            next
          end
          
          begin 
            r = WeatherData.new(timestamp: time, latitude: objects[1].to_f, longitude: objects[2].to_f, pm_ten: objects[3].to_f, pm_two_five: objects[4].to_f, humidity: objects[5].to_f, temperature: objects[6].to_f, filename: filename)
          rescue => e
            puts e
            next
          end
          WeatherData::AREAS.each do |k, v| 
            if (Geocoder::Calculations.distance_between([v[0], v[1]], [r.latitude, r.longitude], :units=>:km) < 8)
              r.area = k
              break
            end
          end
          records << r   
        end
      end
      WeatherData.import records unless records.empty?

      Rails.logger.info "Done processing"
    rescue => e
      Rails.logger.error "Something went wrong with file #{filename}. Error: #{e.to_s}"
      puts "Something went wrong with file #{filename}. Error: #{e.to_s}"
      ProcessInputJob.perform_later(filename)
    end
  end

  private

  def validate_location(latitude, longitude)
    return false if (latitude == 0) or (longitude == 0)
    return true
  end
end
