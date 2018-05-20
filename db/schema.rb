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

ActiveRecord::Schema.define(version: 2018_05_20_191018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_stats", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "index_n"
    t.float "index_avg"
    t.bigint "create_n"
    t.float "create_avg"
    t.index ["user_id"], name: "index_api_stats_on_user_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.integer "state"
    t.datetime "starts_at"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["starts_at"], name: "index_appointments_on_starts_at"
    t.index ["state", "starts_at"], name: "index_appointments_on_state_and_starts_at"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.bigint "appointment_id"
    t.integer "minutes_before"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 0
    t.index ["appointment_id", "state"], name: "index_reminders_on_appointment_id_and_state"
    t.index ["appointment_id"], name: "index_reminders_on_appointment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "email"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_key"
    t.index ["api_key"], name: "index_users_on_api_key", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "api_stats", "users"
  add_foreign_key "appointments", "users"
  add_foreign_key "reminders", "appointments"
end
