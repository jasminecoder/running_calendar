# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_29_001044) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "race_distances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "distance_unit", null: false
    t.decimal "distance_value", precision: 4, scale: 1, null: false
    t.bigint "race_id", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_race_distances_on_race_id"
  end

  create_table "races", force: :cascade do |t|
    t.integer "city", null: false
    t.decimal "cost", precision: 6, scale: 2
    t.datetime "created_at", null: false
    t.boolean "day_of_race_registration", default: false, null: false
    t.string "location_address"
    t.text "location_description", null: false
    t.string "name", limit: 255, null: false
    t.text "notes"
    t.text "organizer_contact"
    t.string "organizer_name"
    t.datetime "published_at"
    t.text "registration_info"
    t.string "registration_url"
    t.datetime "start_time", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_races_on_city"
    t.index ["status"], name: "index_races_on_status"
  end

  add_foreign_key "race_distances", "races", on_delete: :cascade
end
