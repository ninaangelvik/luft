require 'csv'
class DatafilesController < ApplicationController
  def index 
    @files = Datafile.all
  end 

  def create
    @file = Datafile.new(file_params) do |t|
      if params[:datafile][:file]
        t.data      = params[:datafile][:file].read
        t.filename  = params[:datafile][:file].original_filename
        t.displayname = params[:datafile][:file].original_filename
        t.filetype = params[:datafile][:file].content_type
      end
    end
    if @file.nil?
      flash[:error] = "Fil er ikke angitt."
      redirect_to root_path
    elsif @file.filetype != "text/csv"
      flash[:success] = "Kunne ikke laste opp fil grunnet feil filformat."
      redirect_to root_path
    else
      if @file.save
        num_versions = Datafile.where("filename = ?", @file.filename).count
        filename, filetype = @file.filename.split(".")
        if num_versions > 1
          new_filename = filename + "-" + num_versions.to_s + "." + filetype 
          @file.update_attribute("displayname", new_filename)
        end
        Rails.cache.write(@file.id, @file)
        Resque.enqueue(ImportToDatabase, @file.id)
        flash[:success] = "Filen ble lastet opp"
      else 
        flash[:error] = "Filen kunne ikke lastes opp"
      end
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

  private
    def file_params
      params.require(:datafile).permit(:data, :filename, :filetype)
    end
end
