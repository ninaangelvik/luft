class AddDisplayNameToDatafile < ActiveRecord::Migration
  def up
    add_column :datafiles, :displayname, :string
  end

  def down
    remove_column :datafiles, :displayname, :string
  end
end
