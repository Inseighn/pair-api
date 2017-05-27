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

ActiveRecord::Schema.define(version: 20170527002715) do

  create_table "areas", force: :cascade do |t|
    t.string   "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pollutant_levels", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "pollutant_id"
    t.datetime "time"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["pollutant_id"], name: "index_pollutant_levels_on_pollutant_id"
    t.index ["site_id"], name: "index_pollutant_levels_on_site_id"
  end

  create_table "pollutants", force: :cascade do |t|
    t.string   "name"
    t.string   "param"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sites", force: :cascade do |t|
    t.string   "desc"
    t.integer  "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_sites_on_area_id"
  end

end
