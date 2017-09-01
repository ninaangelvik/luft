class AddGroupeName < ActiveRecord::Migration
  def up
    add_column :weather_data, :group, :string
  end

  def down
    remove_column :weather_data, :group, :string
  end
end
