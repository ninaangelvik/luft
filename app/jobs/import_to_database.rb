require 'csv'

class ImportToDatabase
  @queue = :files

  def self.perform(id)
    begin 
      file = Rails.cache.read(id)
      if file.filename.include?("-")
        groupname = file.filename.split("-")[0]
      else
        groupname = file.filename.split(".")[0]
      end 

      csv_text = file.data.split("\n")
      csv_text.each do |line|
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
            record.group   = groupname
            
            record.save! rescue ActiveRecord::RecordNotUnique or ActiveRecord::RecordInvalid
          rescue ArgumentError 
            next
          end
        end
      end
      # S3Store.new(file).store
      Rails.cache.delete(id)
    rescue => e
      puts e
    end
  end
end