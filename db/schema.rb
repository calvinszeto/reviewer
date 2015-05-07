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

ActiveRecord::Schema.define(version: 20150507195432) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "digestions", force: true do |t|
    t.integer  "review_digest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  add_index "digestions", ["review_digest_id"], name: "index_digestions_on_review_digest_id", using: :btree

  create_table "notes", force: true do |t|
    t.integer  "evernote_id"
    t.text     "tags",            default: [], array: true
    t.datetime "note_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "notes_digestions", force: true do |t|
    t.integer  "note_id"
    t.integer  "digestion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes_digestions", ["digestion_id"], name: "index_notes_digestions_on_digestion_id", using: :btree
  add_index "notes_digestions", ["note_id"], name: "index_notes_digestions_on_note_id", using: :btree

  create_table "review_digests", force: true do |t|
    t.string   "name"
    t.text     "tags",                default: [], array: true
    t.string   "recurrence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "next_occurrence"
    t.datetime "previous_occurrence"
  end

  add_index "review_digests", ["user_id"], name: "index_review_digests_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

end
