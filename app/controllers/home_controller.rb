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

  def ready
    self.response_body = "200 OK"
  end

  def alive
    self.response_body = "200 OK"
  end

  def health
    self.response_body = "200 OK"
  end
end
