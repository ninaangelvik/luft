class AlterWeatherData < ActiveRecord::Migration
  def up 
  	remove_column :weather_data, :group, :string 
  	remove_column :weather_data, :dust, :integer

  	add_column :weather_data, :pm_ten, :float
  	add_column :weather_data, :pm_two_five, :float
  end

  def down
  	remove_column :weather_data, :group, :string 
  	remove_column :weather_data, :dust, :integer

  	add_column :weather_data, :pm_ten, :float
  	add_column :weather_data, :pm_two_five, :float
  end
end
