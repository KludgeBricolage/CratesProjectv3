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

ActiveRecord::Schema.define(version: 20160410122139) do

  create_table "active_statuses", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "admins", force: :cascade do |t|
    t.integer "user_id", limit: 4
  end

  add_index "admins", ["user_id"], name: "index_admins_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crates", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.integer  "locations_id",     limit: 4
    t.integer  "states_id",        limit: 4
    t.integer  "qualities_id",     limit: 4
    t.decimal  "price",                          precision: 11, scale: 2
    t.integer  "category_id",      limit: 4
    t.integer  "active_status_id", limit: 4,                              default: 1
  end

  add_index "crates", ["active_status_id"], name: "index_crates_on_active_status_id", using: :btree
  add_index "crates", ["category_id"], name: "index_crates_on_category_id", using: :btree
  add_index "crates", ["locations_id"], name: "index_crates_on_locations_id", using: :btree
  add_index "crates", ["qualities_id"], name: "index_crates_on_qualities_id", using: :btree
  add_index "crates", ["states_id"], name: "index_crates_on_states_id", using: :btree
  add_index "crates", ["user_id", "created_at"], name: "index_crates_on_user_id_and_created_at", using: :btree
  add_index "crates", ["user_id"], name: "index_crates_on_user_id", using: :btree

  create_table "forum_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_comments", force: :cascade do |t|
    t.string   "comment",       limit: 255
    t.integer  "user_id",       limit: 4
    t.integer  "forum_post_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "forum_comments", ["forum_post_id"], name: "index_forum_comments_on_forum_post_id", using: :btree
  add_index "forum_comments", ["user_id"], name: "index_forum_comments_on_user_id", using: :btree

  create_table "forum_posts", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.text     "description",       limit: 65535
    t.integer  "user_id",           limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "forum_category_id", limit: 4
    t.boolean  "is_pin",                          default: false
    t.boolean  "is_lock",                         default: false
    t.datetime "last_comment_time",                               null: false
  end

  add_index "forum_posts", ["forum_category_id"], name: "index_forum_posts_on_forum_category_id", using: :btree
  add_index "forum_posts", ["user_id"], name: "index_forum_posts_on_user_id", using: :btree

  create_table "group_memberships", force: :cascade do |t|
    t.integer  "member_id",       limit: 4,   null: false
    t.string   "member_type",     limit: 255, null: false
    t.integer  "group_id",        limit: 4
    t.string   "group_type",      limit: 255
    t.string   "group_name",      limit: 255
    t.string   "membership_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_memberships", ["group_name"], name: "index_group_memberships_on_group_name", using: :btree
  add_index "group_memberships", ["group_type", "group_id"], name: "index_group_memberships_on_group_type_and_group_id", using: :btree
  add_index "group_memberships", ["member_type", "member_id"], name: "index_group_memberships_on_member_type_and_member_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string  "name",         limit: 255
    t.string  "type",         limit: 255
    t.integer "member_count", limit: 4,   default: 0
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "name",       limit: 255
    t.string   "long",       limit: 255
    t.string   "lat",        limit: 255
  end

  create_table "pictures", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "crate_id",           limit: 4
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "first_name",   limit: 255
    t.string   "middle_name",  limit: 255
    t.string   "last_name",    limit: 255
    t.string   "address",      limit: 255
    t.string   "phone_number", limit: 255
    t.string   "gender",       limit: 255
    t.date     "birth_date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "profiles", ["user_id", "created_at"], name: "index_profiles_on_user_id_and_created_at", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "qualities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "qualities", ["name"], name: "index_qualities_on_name", using: :btree

  create_table "queries", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.integer  "user_id",     limit: 4
    t.integer  "crate_id",    limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "is_lock",                   default: false
  end

  add_index "queries", ["crate_id"], name: "index_queries_on_crate_id", using: :btree
  add_index "queries", ["user_id"], name: "index_queries_on_user_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.string   "rating_name", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "replies", force: :cascade do |t|
    t.text     "body",       limit: 65535
    t.integer  "user_id",    limit: 4
    t.integer  "query_id",   limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "replies", ["query_id"], name: "index_replies_on_query_id", using: :btree
  add_index "replies", ["user_id"], name: "index_replies_on_user_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.text     "description", limit: 65535
    t.integer  "reported_id", limit: 4
    t.integer  "reporter",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "searches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "status",     limit: 255
    t.string   "color",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "forum_post_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",               default: true
  end

  add_index "subscriptions", ["forum_post_id"], name: "index_subscriptions_on_forum_post_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "crate_id",   limit: 4
    t.integer  "tag_id",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "taggings", ["crate_id"], name: "index_taggings_on_crate_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_ratings", force: :cascade do |t|
    t.integer  "rating_id",    limit: 4
    t.integer  "user_id",      limit: 4
    t.integer  "rated_person", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "user_ratings", ["rating_id"], name: "index_user_ratings_on_rating_id", using: :btree
  add_index "user_ratings", ["user_id"], name: "index_user_ratings_on_user_id", using: :btree

  create_table "user_statuses", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",               limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "password_digest",     limit: 255
    t.string   "remember_digest",     limit: 255
    t.string   "alias",               limit: 255
    t.string   "activation_digest",   limit: 255
    t.boolean  "activated"
    t.datetime "activated_at"
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.string   "reset_digest",        limit: 255
    t.datetime "reset_sent_at"
    t.integer  "user_status_id",      limit: 4,   default: 1
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["user_status_id"], name: "index_users_on_user_status_id", using: :btree

  add_foreign_key "admins", "users"
  add_foreign_key "crates", "categories"
  add_foreign_key "crates", "users"
  add_foreign_key "forum_comments", "forum_posts"
  add_foreign_key "forum_comments", "users"
  add_foreign_key "forum_posts", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "queries", "crates"
  add_foreign_key "queries", "users"
  add_foreign_key "replies", "queries"
  add_foreign_key "replies", "users"
  add_foreign_key "subscriptions", "forum_posts"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "taggings", "crates"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_ratings", "ratings"
  add_foreign_key "user_ratings", "users"
end
