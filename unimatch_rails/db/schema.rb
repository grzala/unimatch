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

ActiveRecord::Schema.define(version: 20161101155405) do

  create_table "billing_histories", force: :cascade do |t|
    t.date     "date"
    t.float    "amount"
    t.integer  "society_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["society_id"], name: "index_billing_histories_on_society_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.time     "time"
    t.string   "description"
    t.string   "location"
    t.boolean  "fixed"
    t.boolean  "frequency"
    t.float    "cost"
    t.integer  "society_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["society_id"], name: "index_events_on_society_id"
  end

  create_table "interest_groups", force: :cascade do |t|
    t.integer  "interests_id"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["interests_id"], name: "index_interest_groups_on_interests_id"
  end

  create_table "interests", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.integer  "society_id"
    t.boolean  "admin",      default: false
    t.index ["society_id"], name: "index_members_on_society_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "societies", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.float    "cost"
    t.boolean  "paid"
    t.boolean  "recurring"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "universities", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_universities_on_user_id"
  end

  create_table "user_interests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "interest_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["interest_id"], name: "index_user_interests_on_interest_id"
    t.index ["user_id"], name: "index_user_interests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "surname"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
