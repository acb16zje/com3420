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

ActiveRecord::Schema.define(version: 20180226051646) do

  create_table "assets", force: :cascade do |t|
    t.string "category"
    t.string "condition"
    t.string "name"
    t.string "location"
    t.string "peripherals"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "booking_states", force: :cascade do |t|
    t.string "process_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "items", force: :cascade do |t|
    t.string "category"
    t.string "condition"
    t.string "name"
    t.string "location"
    t.string "peripherals"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manufacturer"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "res_bookings", force: :cascade do |t|
    t.integer "item_id"
    t.string "user_email"
    t.integer "manager_id"
    t.datetime "out_date"
    t.datetime "in_date"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state_id"
    t.integer "booking_states_id"
    t.integer "items_id"
    t.index ["booking_states_id"], name: "index_res_bookings_on_booking_states_id"
    t.index ["items_id"], name: "index_res_bookings_on_items_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "forename"
    t.string "surname"
    t.string "email"
    t.string "password"
    t.string "phone"
    t.string "department"
    t.integer "permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "permissions_id"
    t.index ["permissions_id"], name: "index_users_on_permissions_id"
  end

end
