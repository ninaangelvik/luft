# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170915085647) do

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "books", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.string   "author",       limit: 255
    t.date     "published_on"
    t.text     "description",  limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "image_url",    limit: 255
    t.string   "creator_id",   limit: 255
  end

  add_index "books", ["creator_id"], name: "index_books_on_creator_id", using: :btree

  create_table "datafiles", force: :cascade do |t|
    t.string   "filename",   limit: 255, null: false
    t.string   "filetype",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "size",       limit: 4
  end

  create_table "weather_data", force: :cascade do |t|
    t.float    "latitude",    limit: 24,  null: false
    t.float    "longitude",   limit: 24,  null: false
    t.float    "dust",        limit: 24,  null: false
    t.integer  "humidity",    limit: 4,   null: false
    t.integer  "temperature", limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "group",       limit: 255
    t.datetime "timestamp"
  end

  add_index "weather_data", ["latitude", "longitude"], name: "index_weather_data_on_time_and_latitude_and_longitude", unique: true, using: :btree

end
