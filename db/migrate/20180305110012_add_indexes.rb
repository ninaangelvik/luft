class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :weather_data, :area
  	add_index :weather_data, :longitude
  	add_index :weather_data, :latitude
  	add_index :weather_data, :timestamp
  end
end
