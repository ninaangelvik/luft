class AddOriginalFilenameToDatafiles < ActiveRecord::Migration
  def up
  	add_column :datafiles, :original_filename, :string, :null => false
  end

  def down
  	remove_column :datafiles, :original_filename
  end
end
