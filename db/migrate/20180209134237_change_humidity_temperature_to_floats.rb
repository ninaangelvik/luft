class ChangeHumidityTemperatureToFloats < ActiveRecord::Migration
  def change
  	change_column :weather_data, :temperature, :float
  	change_column :weather_data, :humidity, :float
  end
end
