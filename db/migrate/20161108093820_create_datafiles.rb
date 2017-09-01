class CreateDatafiles < ActiveRecord::Migration
  def up
    create_table :datafiles do |t|
      t.string :filename, null: false
      t.binary :data,     null: false
      t.string :filetype
      t.timestamps null: false
    end
  end
  def down
    drop_table :datafiles
  end
end
