class AddAreaToWeatherRecord < ActiveRecord::Migration
  def up
  	add_column :weather_data, :area, :string, :default => ""
  end

  def down
  	remove_column :weather_data, :area
  end
end
