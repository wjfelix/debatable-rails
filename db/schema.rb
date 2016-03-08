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

ActiveRecord::Schema.define(version: 20160307234852) do

  create_table "categories", force: true do |t|
    t.string   "category_name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debate_styles", force: true do |t|
    t.string   "debate_style", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debate_users", force: true do |t|
    t.boolean  "is_judge",             default: false, null: false
    t.boolean  "is_connected",         default: false, null: false
    t.string   "position_description"
    t.string   "tok_session"
    t.integer  "level",                default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "debate_id"
  end

  create_table "debater_invites", force: true do |t|
    t.string   "invite_message"
    t.string   "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "debate_id"
    t.integer  "user_id"
  end

  create_table "debates", force: true do |t|
    t.string   "topic",                           null: false
    t.string   "name",                            null: false
    t.string   "description"
    t.string   "tok_session_id",                  null: false
    t.integer  "size",            default: 0,     null: false
    t.boolean  "public",          default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "debate_style_id"
  end

  create_table "feedbacks", force: true do |t|
    t.string   "name",             default: "Anonymous"
    t.string   "feedback_content",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "firetalk_debaters", force: true do |t|
    t.integer  "points",               default: 3, null: false
    t.string   "position_description"
    t.string   "email",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "firetalk_id"
    t.integer  "user_id"
  end

  create_table "firetalks", force: true do |t|
    t.string   "topic",                          null: false
    t.string   "name",                           null: false
    t.string   "description"
    t.string   "tok_session_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "category_id"
    t.boolean  "is_public",      default: false
    t.boolean  "in_progress",    default: false
    t.boolean  "full",           default: false
  end

  create_table "invites", force: true do |t|
    t.string   "email"
    t.string   "from"
    t.string   "message"
    t.string   "path"
    t.boolean  "is_seen",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "moderator_invites", force: true do |t|
    t.string   "invite_message", default: "Hello, I'd like you to moderate my debate!"
    t.string   "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "debate_id"
    t.integer  "user_id"
  end

  create_table "newsletter_subscriptions", force: true do |t|
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.boolean  "seen"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "posts", force: true do |t|
    t.integer  "endorsements"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "firstname",                       null: false
    t.string   "lastname",                        null: false
    t.string   "email",                           null: false
    t.string   "school"
    t.string   "password_digest",                 null: false
    t.boolean  "is_validated",    default: false, null: false
    t.string   "validation_code"
    t.integer  "level",           default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fullname"
  end

end
