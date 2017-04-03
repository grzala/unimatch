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

ActiveRecord::Schema.define(version: 20170330154712) do

  create_table "billing_histories", force: :cascade do |t|
    t.date     "date"
    t.float    "amount"
    t.integer  "society_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["society_id"], name: "index_billing_histories_on_society_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_invites", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "event_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["event_id"], name: "index_event_invites_on_event_id"
    t.index ["recipient_id"], name: "index_event_invites_on_recipient_id"
    t.index ["sender_id"], name: "index_event_invites_on_sender_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.integer  "time"
    t.string   "description"
    t.string   "location"
    t.integer  "frequency",      default: 0
    t.float    "cost",           default: 0.0
    t.boolean  "canceled",       default: false
    t.integer  "society_id"
    t.integer  "event_group_id"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "favourite_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "favourite_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["favourite_id"], name: "index_favourite_users_on_favourite_id"
    t.index ["user_id"], name: "index_favourite_users_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "interest_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interests", force: :cascade do |t|
    t.integer  "interest_group_id"
    t.string   "name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["interest_group_id"], name: "index_interests_on_interest_group_id"
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id",                    null: false
    t.integer  "society_id",                 null: false
    t.boolean  "admin",      default: false
    t.index ["society_id"], name: "index_members_on_society_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.boolean  "read",            default: false
    t.integer  "sender_id"
    t.integer  "conversation_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "sender"
    t.string   "link"
    t.string   "information"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.boolean  "seen",            default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "notif_type"
    t.index ["conversation_id"], name: "index_notifications_on_conversation_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id",    null: false
    t.integer  "event_id",   null: false
    t.index ["event_id"], name: "index_participants_on_event_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "reccomendations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "match_type",  limit: 1
    t.integer  "match_id"
    t.float    "coefficient"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["user_id"], name: "index_reccomendations_on_user_id"
  end

  create_table "recipients", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "conversation_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["conversation_id"], name: "index_recipients_on_conversation_id"
    t.index ["user_id"], name: "index_recipients_on_user_id"
  end

  create_table "societies", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "paid",        default: false
    t.boolean  "recurring",   default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "society_interests", force: :cascade do |t|
    t.integer  "society_id"
    t.integer  "interest_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["interest_id"], name: "index_society_interests_on_interest_id"
    t.index ["society_id"], name: "index_society_interests_on_society_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_interests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "interest_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "important",   default: false
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
    t.string   "avatar"
    t.string   "slug"
    t.index ["slug"], name: "index_users_on_slug"
  end

end
