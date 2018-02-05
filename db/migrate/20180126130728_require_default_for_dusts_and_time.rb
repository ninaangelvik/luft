class RequireDefaultForDustsAndTime < ActiveRecord::Migration
  def change
  	change_column :weather_data, :pm_ten, :float, :null => false
  	change_column :weather_data, :pm_two_five, :float, :null => false
  	change_column :weather_data, :timestamp, :datetime, :null => false
  end
end
