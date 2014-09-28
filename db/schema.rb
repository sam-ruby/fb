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

ActiveRecord::Schema.define(version: 20140928020030) do

  create_table "access_token", force: true do |t|
    t.string "token"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "fb_posts", force: true do |t|
    t.string   "post_id"
    t.datetime "post_created"
    t.string   "type"
    t.string   "video_id"
  end

  create_table "play_lists", force: true do |t|
    t.string   "name"
    t.text     "description", limit: 16777215
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", force: true do |t|
    t.string   "fb_post_id"
    t.datetime "fb_created_time"
    t.datetime "fb_updated_time"
    t.string   "video_id"
    t.datetime "published_at"
    t.string   "channel_id"
    t.text     "title"
    t.text     "description"
    t.string   "image_url"
    t.string   "channel_title"
  end

  add_index "songs", ["fb_created_time"], name: "index_songs_on_fb_created_time", using: :btree
  add_index "songs", ["fb_post_id"], name: "index_songs_on_fb_post_id", unique: true, using: :btree
  add_index "songs", ["fb_updated_time"], name: "index_songs_on_fb_updated_time", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
