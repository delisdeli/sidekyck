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

ActiveRecord::Schema.define(version: 20140107185736) do

  create_table "applications", force: true do |t|
    t.integer  "listing_id"
    t.integer  "applicant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applications", ["listing_id"], name: "index_applications_on_listing_id"

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id"

  create_table "listings", force: true do |t|
    t.decimal  "price"
    t.text     "description"
    t.string   "title"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "status"
    t.integer  "positions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.integer  "user_id"
    t.string   "audience"
  end

  add_index "listings", ["user_id"], name: "index_listings_on_user_id"

  create_table "notifications", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.boolean  "seen"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tunnel"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "providers", force: true do |t|
    t.string   "name"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth_token"
    t.time     "oauth_expires_at"
  end

  add_index "providers", ["user_id"], name: "index_providers_on_user_id"

  create_table "services", force: true do |t|
    t.integer  "listing_id"
    t.string   "status"
    t.datetime "start_time"
    t.datetime "completion_time"
    t.integer  "customer_id"
    t.integer  "provider_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["listing_id"], name: "index_services_on_listing_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

end
