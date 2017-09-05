require 'csv'
class DatafilesController < ApplicationController  
  def index 
    @files = Datafile.all
  end 

  def create
    input_file = params[:datafile][:file]
    
    if input_file.content_type != "text/csv"
      flash[:error] = "Filen er ikke av type '.csv'. Vennligst prøv en annen fil."
      redirect_to root_path and return
    end

    begin 
      datafile = Datafile.new do |f| 
        f.filename = input_file.original_filename
        f.displayname = input_file.original_filename
        f.filetype = input_file.content_type
        f.size = input_file.size
        f.school = "Kongsbakken VGS"
        f.group = "Powderpuffs"
        f.url = "/files/hei"
      end
       

      if datafile.save
        flash[:success] = "Filen ble lastet opp"
        redirect_to root_path
      end
    rescue => error
      flash[:error] = "Filen kunne ikke lastes opp. #{error.to_s}"
      redirect_to root_path
    end
  end  
  
  def get_data
    from_date = params[:fromtime].split(".")
    to_date = params[:totime].split(".")

    from = from_date.reverse.join("-").to_time.in_time_zone("Copenhagen")
    to = to_date.reverse.join("-").to_time.in_time_zone("Copenhagen")


    data = WeatherData.where("timestamp between ? and ?", from.beginning_of_day, to.end_of_day)
    CSV.open(Rails.root.join('tmp', 'collected_data.csv'), "wb") do |csv|
      csv << WeatherData.attribute_names
      data.each do |record|
        csv << record.attributes.values
      end
    end
    send_file(Rails.root.join('tmp', 'collected_data.csv'))

  end

  def get_id
    files = Datafile.all

    CSV.open(Rails.root.join('tmp', 'file_ids.csv'), "wb") do |csv|
      csv << ["Filnavn", "Displaynavn", "Id"]
      files.each do |file|
        csv << [file.filename, file.displayname, file.id]
      end  
    end

    send_file(Rails.root.join('tmp', 'file_ids.csv'))
  end
end
