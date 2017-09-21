class ChangeDatafileTable < ActiveRecord::Migration
  def up
    remove_column :datafiles, :data, :binary

    add_column :datafiles, :size, :integer
    add_column :datafiles, :school, :string
    add_column :datafiles, :group, :string
    add_column :datafiles, :url, :string
  end

  def down
    add_column :datafiles, :data, :binary

    remove_column :datafiles, :size, :integer
    remove_column :datafiles, :school, :string
    remove_column :datafiles, :group, :string
    remove_column :datafiles, :url, :string
  end
end

