class CreateWeatherData < ActiveRecord::Migration
  def up
    create_table :weather_data do |t|
      t.string :time, null: false
      t.float :latitude, null: false 
      t.float :longitude, null: false
      t.float :dust, null: false
      t.integer :humidity, null: false
      t.integer :temperature, null: false

      t.timestamps null: false
    end

    add_index :weather_data, [:time, :latitude, :longitude], unique: true
  end
  def down 
    remove_index :weather_data, [:time, :latitude, :longitude] if index_exists? :weather_data, [:time, :latitude, :longitude]
    drop_table :weather_data
  end
end
