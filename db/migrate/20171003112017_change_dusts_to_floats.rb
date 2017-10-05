class ChangeDustsToFloats < ActiveRecord::Migration
  def change
  	change_column :weather_data, :pm_ten, :float
  	change_column :weather_data, :pm_two_five, :float
  end
end
