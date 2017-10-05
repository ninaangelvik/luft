class ChangeTypeForGps < ActiveRecord::Migration
  def change
  	change_column :weather_data, :longitude, :float, :limit => 26
  	change_column :weather_data, :latitude, :float, :limit => 26
  end
end
