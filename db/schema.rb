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

ActiveRecord::Schema.define(version: 20140310152359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "song_infos", force: true do |t|
    t.string   "video_id"
    t.datetime "published_at"
    t.string   "channel_id"
    t.text     "title"
    t.text     "description"
    t.string   "image_url"
    t.string   "channel_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "song_infos", ["video_id"], name: "video_id_idx", unique: true, using: :btree

  create_table "songs", force: true do |t|
    t.string "name"
    t.string "url"
    t.string "title"
    t.string "movie_name"
  end

end
