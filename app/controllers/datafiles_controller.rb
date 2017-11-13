require 'csv'
class DatafilesController < ApplicationController  
  def index 
    @files = Datafile.all
  end 

  def create  
    begin 
      datafile = Datafile.new do |f| 
        f.filename = generate_filename(params["Filename"])
        f.original_filename = params["Filename"]
        f.filetype = params["ContentType"]
        f.size = params["Size"]
      end
       
      if datafile.save
        file = StorageBucket.files.new(
          key: "#{datafile.filename}",
          body: params["Body"],
          public: false
        )
        if file.save
          ProcessInputJob.perform_later(datafile.filename)
          render json: {
            status: 200,
            message: "Successfully uploaded file",
          }.to_json
        end
      end
    rescue => error
      render json: {
            status: 500,
            message: "Successfully created todo list.",
          }.to_json
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

  private

  def generate_filename(filename)
    existing_files = Datafile.where(original_filename: filename)

    unless existing_files.empty?
      ext = File.extname(filename)
      basename = File.basename(filename, ext)

      return "#{basename}(#{existing_files.count})#{ext}"
    else 
      return filename
    end
  end
end
