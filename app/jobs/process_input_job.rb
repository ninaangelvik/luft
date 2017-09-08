class ProcessInputJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    # Do something later
    # begin 
    csv_text = data.split("\n")
    csv_text.each do |line|
      if line.include? "Time" or line.blank?
        next
      end
      if line.include? (";")
        objects = line.split(";")
      elsif line.include? (",")        
        objects = line.split(",")
      end
    end
    puts "Hello #{name}"
    puts objects
    #     unless objects.empty?
    #       begin 
    #         record = WeatherData.new
    #         record.timestamp    = objects[0].to_time.in_time_zone("Copenhagen")  
    #         record.latitude     = objects[1]
    #         record.longitude    = objects[2]
    #         record.dust         = objects[3] 
    #         record.humidity     = objects[4]
    #         record.temperature  = objects[5]
    #         record.group        = ""
            
    #         record.save! 
    #       rescue => error
    #         next
    #       end
    #     end
    #   end
    # rescue => e
    #   puts e
    # end
  end
end
