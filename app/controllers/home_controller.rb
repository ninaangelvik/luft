class HomeController < ApplicationController
  def index
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

  def health
    head :ok, content_type: "text/html"
  end

  def say
    ProcessInputJob.perform_later(params[:name])
    render plain: "ok"
  end
end
