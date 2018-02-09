class AddIndexOnFilename < ActiveRecord::Migration
  def change
  	add_index :weather_data, :filename
  end
end
