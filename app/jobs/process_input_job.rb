class ProcessInputJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    # Do something later
    begin 
      csv_text = data.split("\n")
      csv_text.each do |line|
        pp line
        if line.include? "Time" or line.blank?
          next
        end
        if line.include? (";")
          objects = line.split(";")
        elsif line.include? (",")        
          objects = line.split(",")
        end

        unless objects.empty?
          begin 
            record = WeatherData.new
            record.timestamp    = objects[0].to_time.in_time_zone("Copenhagen")  
            record.latitude     = objects[1]
            record.longitude    = objects[2]
            record.dust         = objects[3] 
            record.humidity     = objects[4]
            record.temperature  = objects[5]
            record.group        = ""
            
            record.save! 
          rescue => error
            next
          end
        end
      end
      return true
    rescue => e
      return e
    end
  end
end
