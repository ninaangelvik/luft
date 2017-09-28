class ProcessInputJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    # Do something later
    begin 
      start = Time.now
      Rails.logger.info "Entering perform_later"
      puts "Entering perform_later"
      csv_text = data.split("\n")
      csv_text.each do |line|
        # pp line
        if line.include? "Time" or line.blank?
          # Rails.logger.info "Skipping line"
          # puts "Skipping line"
          next
        end
        if line.include? (";")
          objects = line.split(";")
        elsif line.include? (",")        
          objects = line.split(",")
        end

        # Rails.logger.error "Row was not parsed correctly" if objects.empty?
        # puts objects
        unless objects.empty?
          begin 
            record = WeatherData.new
            record.timestamp    = objects[0].to_time.in_time_zone("Copenhagen")  
            record.latitude     = objects[1]
            record.longitude    = objects[2]
            record.pm_ten       = objects[3] 
            record.pm_two_five  = objects[4] 
            record.humidity     = objects[5]
            record.temperature  = objects[6]
            
            record.save! 
          rescue => error
            Rails.logger.error "Could not add row due to #{error.to_s}"
            next
          end
        end
      end
      stop = Time.now
      Rails.logger.info "Done processing"
      Rails.logger.info "Time spent: #{stop - start}"
      puts "Time spent: #{stop - start}"
      return true
    rescue => e
      Rails.logger.error "Something went wrong #{e.to_s}"
      puts "Something went wrong #{e.to_s}"
      return e
    end
  end
end
