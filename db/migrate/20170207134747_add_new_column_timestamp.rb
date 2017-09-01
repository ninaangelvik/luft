class AddNewColumnTimestamp < ActiveRecord::Migration
  def up
    add_column :weather_data, :timestamp, :datetime
    remove_column :weather_data, :time, :string
  end

  def down
    remove_column :weather_data, :timestamp, :datetime
    add_column :weather_data, :time, :string
  end
end
