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

ActiveRecord::Schema[7.0].define(version: 2024_04_03_203216) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "approvals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "votetype"
    t.uuid "voter_id", null: false
    t.uuid "post_id", null: false
    t.integer "approvals_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_approvals_on_post_id"
    t.index ["voter_id", "post_id"], name: "index_approvals_on_voter_id_and_post_id", unique: true
    t.index ["voter_id"], name: "index_approvals_on_voter_id"
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "body"
    t.uuid "post_id", null: false
    t.uuid "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "medical_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "patient_id", null: false
    t.string "record_type"
    t.date "record_date"
    t.text "notes"
    t.uuid "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_medical_records_on_created_by_id"
    t.index ["patient_id"], name: "index_medical_records_on_patient_id"
  end

  create_table "noticed_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.string "record_type"
    t.uuid "record_id"
    t.jsonb "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notifications_count"
    t.index ["record_type", "record_id"], name: "index_noticed_events_on_record"
  end

  create_table "noticed_notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.uuid "event_id", null: false
    t.string "recipient_type", null: false
    t.uuid "recipient_id", null: false
    t.datetime "read_at", precision: nil
    t.datetime "seen_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_noticed_notifications_on_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_noticed_notifications_on_recipient"
  end

  create_table "posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "author_id"
    t.text "body"
    t.string "image"
    t.boolean "trusted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "approvals_count", default: 0, null: false
    t.uuid "medical_record_id"
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.index ["author_id"], name: "index_posts_on_author_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.string "profile_picture"
    t.boolean "trust"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.string "voter_type"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "votable_id"
    t.uuid "voter_id"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_and_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_and_scope"
  end

  add_foreign_key "approvals", "posts"
  add_foreign_key "approvals", "users", column: "voter_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "medical_records", "users", column: "created_by_id"
  add_foreign_key "medical_records", "users", column: "patient_id"
  add_foreign_key "posts", "users", column: "author_id"
end
