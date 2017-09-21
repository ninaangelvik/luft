class RemoveUniquenessIndex < ActiveRecord::Migration
  def change
  	remove_index :weather_data, :name => "index_weather_data_on_time_and_latitude_and_longitude"
  end
end
