class HomeController < ApplicationController
  def index
    ImportToDatabaseJob.perform_later("Nina")
    render plain: 'OK'
  end

  def download
    require 'csv'
    file = Datafile.find(params[:id])
    lines = file.data.split("\n")
    CSV.open(Rails.root.join('tmp', '#{file.filename}.csv'), "wb") do |csv|
      lines.each do |line|
        csv << line.parse_csv
      end
    end
    send_file(Rails.root.join('tmp', '#{file.filename}.csv'), :filename => file.filename)
  end

end
