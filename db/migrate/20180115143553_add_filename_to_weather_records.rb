class AddFilenameToWeatherRecords < ActiveRecord::Migration
  def up
  	add_column :weather_data, :filename, :string, :null => false
  end

  def down
  	add_column :weather_data, :filename
  end
end
