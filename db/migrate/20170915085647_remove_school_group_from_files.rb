class RemoveSchoolGroupFromFiles < ActiveRecord::Migration
  def up
  	remove_column :datafiles, :school, :string
  	remove_column :datafiles, :group, :string 
  	remove_column :datafiles, :displayname, :string 
  	remove_column :datafiles, :url, :string
  end

  def down
  	add_column :datafiles, :school, :string
    add_column :datafiles, :group, :string
  	add_column :datafiles, :displayname, :string 
  	add_column :datafiles, :url, :string
  end
end
