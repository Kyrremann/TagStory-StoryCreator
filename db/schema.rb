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

ActiveRecord::Schema.define(version: 20150928185500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorgroups", force: :cascade do |t|
    t.integer  "story_id"
    t.integer  "user_id"
    t.string   "permission", default: "edit", null: false
    t.boolean  "owner",      default: false,  null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "authorgroups", ["story_id"], name: "index_authorgroups_on_story_id", using: :btree
  add_index "authorgroups", ["user_id"], name: "index_authorgroups_on_user_id", using: :btree

  create_table "game_options", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "type",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "game_options", ["tag_id"], name: "index_game_options_on_tag_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "belongs_to", null: false
    t.string   "url",        null: false
    t.integer  "owner",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string   "title",                             null: false
    t.string   "author",                            null: false
    t.string   "description",                       null: false
    t.string   "status",          default: "draft", null: false
    t.string   "age_group",                         null: false
    t.string   "language",                          null: false
    t.string   "country",                           null: false
    t.string   "city",                              null: false
    t.string   "place",                             null: false
    t.string   "estimated_time"
    t.string   "url"
    t.string   "version",         default: "0",     null: false
    t.datetime "first_published"
    t.datetime "last_published"
    t.boolean  "published",       default: false,   null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer  "story_id"
    t.string   "title",                          null: false
    t.string   "description",                    null: false
    t.string   "question"
    t.string   "travel_button"
    t.string   "tag_type",                       null: false
    t.string   "game_mode",     default: "none", null: false
    t.boolean  "endpoint",      default: false,  null: false
    t.boolean  "skippable",     default: true,   null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_top"
    t.string   "image_middle"
    t.string   "image_bottom"
  end

  add_index "tags", ["story_id"], name: "index_tags_on_story_id", using: :btree

  create_table "travel_options", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "title",                           null: false
    t.string   "answer"
    t.string   "help_text"
    t.integer  "next_tag",                        null: false
    t.string   "method",         default: "text", null: false
    t.integer  "map_zoom_level", default: 18
    t.integer  "gps_radius",     default: 15
    t.string   "gps_latitude"
    t.string   "gps_longitude"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "travel_options", ["tag_id"], name: "index_travel_options_on_tag_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",   null: false
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.string   "email",      null: false
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "uid"
  end

end
