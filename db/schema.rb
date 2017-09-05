# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170905124332) do

  create_table "datafiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "filename",    null: false
    t.string   "filetype"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "displayname"
    t.integer  "size"
    t.string   "school"
    t.string   "group"
    t.string   "url"
  end

  create_table "weather_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float    "latitude",    limit: 24, null: false
    t.float    "longitude",   limit: 24, null: false
    t.float    "dust",        limit: 24, null: false
    t.integer  "humidity",               null: false
    t.integer  "temperature",            null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "group"
    t.datetime "timestamp"
    t.index ["latitude", "longitude"], name: "index_weather_data_on_time_and_latitude_and_longitude", unique: true, using: :btree
  end

end
