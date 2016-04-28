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

ActiveRecord::Schema.define(version: 20160428175935) do

  create_table "affiliations", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.integer  "school_id",        limit: 4
    t.boolean  "is_primary",       limit: 1,   default: false, null: false
    t.boolean  "is_assignment",    limit: 1,   default: true,  null: false
    t.boolean  "is_preference",    limit: 1,   default: false, null: false
    t.boolean  "is_active",        limit: 1,   default: true,  null: false
    t.string   "concentration",    limit: 255
    t.boolean  "graduated",        limit: 1
    t.boolean  "is_fallback",      limit: 1
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "provider",         limit: 255
    t.string   "institution_type", limit: 255
    t.string   "year",             limit: 255
  end

  add_index "affiliations", ["school_id"], name: "index_affiliations_on_school_id", using: :btree
  add_index "affiliations", ["user_id"], name: "index_affiliations_on_user_id", using: :btree

  create_table "ahoy_events", force: :cascade do |t|
    t.uuid     "visit_id",   limit: 16
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.text     "properties", limit: 65535
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                 null: false
    t.boolean  "bookmarked", limit: 1, default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "project_id", limit: 4
  end

  add_index "bookmarks", ["project_id", "user_id"], name: "index_bookmarks_on_project_id_and_user_id", using: :btree
  add_index "bookmarks", ["project_id"], name: "index_bookmarks_on_project_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,     null: false
    t.integer  "work_id",    limit: 4,     null: false
    t.text     "body",       limit: 65535, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "project_id", limit: 4,     null: false
  end

  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree
  add_index "comments", ["work_id", "user_id"], name: "index_comments_on_work_id_and_user_id", using: :btree

  create_table "diffs", force: :cascade do |t|
    t.integer  "work1",      limit: 4,        null: false
    t.integer  "work2",      limit: 4,        null: false
    t.integer  "project_id", limit: 4
    t.text     "diff_md",    limit: 16777215
    t.text     "diff_html",  limit: 16777215
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "diff_text",  limit: 16777215
    t.text     "left",       limit: 16777215
    t.text     "right",      limit: 16777215
    t.text     "right_text", limit: 16777215
    t.text     "left_text",  limit: 16777215
  end

  add_index "diffs", ["project_id"], name: "index_diffs_on_project_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gradients", force: :cascade do |t|
    t.integer  "grad",       limit: 4, null: false
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "work_id",    limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "gradients", ["user_id", "work_id"], name: "index_gradients_on_user_id_and_work_id", unique: true, using: :btree
  add_index "gradients", ["work_id"], name: "index_gradients_on_work_id", using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id",   limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "controller_name",     limit: 255
    t.string   "action_name",         limit: 255
    t.string   "view_name",           limit: 255
    t.string   "request_hash",        limit: 255
    t.string   "ip_address",          limit: 255
    t.string   "session_hash",        limit: 255
    t.string   "message",             limit: 255
    t.text     "referrer",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "linked_accounts", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.string   "provider",            limit: 255
    t.string   "uid",                 limit: 255
    t.string   "name",                limit: 255
    t.string   "email",               limit: 255
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "image_url",           limit: 255
    t.string   "location",            limit: 255
    t.text     "oauth_info_json",     limit: 16777215
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.text     "oauth_raw_info_json", limit: 16777215
    t.string   "accesstoken",         limit: 255
  end

  add_index "linked_accounts", ["provider", "uid"], name: "index_on_provider_and_uid", using: :btree
  add_index "linked_accounts", ["uid"], name: "index_linked_accounts_on_uid", using: :btree
  add_index "linked_accounts", ["user_id"], name: "index_linked_accounts_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.integer  "school_id",         limit: 4
    t.string   "author_name",       limit: 255
    t.text     "file_content_md",   limit: 16777215
    t.text     "file_content_html", limit: 16777215
    t.text     "file_content_text", limit: 16777215
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "works_count",       limit: 4,        default: 0,    null: false
    t.boolean  "is_public",         limit: 1,        default: true, null: false
    t.boolean  "is_collaborative",  limit: 1,        default: true, null: false
    t.string   "name",              limit: 255
    t.string   "slug",              limit: 255
    t.integer  "recent_work_id",    limit: 4
    t.boolean  "anonymouse",        limit: 1
    t.string   "school_name",       limit: 255
    t.integer  "impressions_count", limit: 4,        default: 0,    null: false
    t.integer  "bookmarks_count",   limit: 4,        default: 0,    null: false
    t.string   "description",       limit: 255
    t.integer  "diffs_count",       limit: 4,        default: 0,    null: false
    t.integer  "comments_count",    limit: 4,        default: 0,    null: false
    t.integer  "revisions_count",   limit: 4,        default: 0,    null: false
  end

  add_index "projects", ["school_id"], name: "index_projects_on_school_id", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "recommendeds", force: :cascade do |t|
    t.string   "work_id",    limit: 255, null: false
    t.string   "user_id",    limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "revisions", force: :cascade do |t|
    t.integer  "work_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.text     "data",       limit: 16777215
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "revisions", ["project_id"], name: "index_revisions_on_project_id", using: :btree
  add_index "revisions", ["work_id"], name: "index_revisions_on_work_id", using: :btree

  create_table "schools", force: :cascade do |t|
    t.integer  "Institution_ID",           limit: 4
    t.string   "Institution_Name",         limit: 255
    t.string   "Institution_Address",      limit: 255
    t.string   "Institution_City",         limit: 255
    t.string   "Institution_State",        limit: 255
    t.string   "Institution_Zip",          limit: 255
    t.string   "Institution_Phone",        limit: 255
    t.string   "Institution_OPEID",        limit: 255
    t.string   "Institution_IPEDS_UnitID", limit: 255
    t.string   "Institution_Web_Address",  limit: 255
    t.string   "Accreditation_Type",       limit: 255
    t.string   "Agency_Name",              limit: 255
    t.string   "Agency_Status",            limit: 255
    t.string   "Program_Name",             limit: 255
    t.string   "Accreditation_Status",     limit: 255
    t.string   "Accreditation_Date_Type",  limit: 255
    t.string   "Periods",                  limit: 255
    t.string   "Last_Action",              limit: 255
    t.string   "school_domain_slice",      limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "works_count",              limit: 4,     default: 0, null: false
    t.integer  "affiliations_count",       limit: 4,     default: 0, null: false
    t.string   "slug",                     limit: 255
    t.boolean  "is_academic",              limit: 1
    t.string   "favicon",                  limit: 255
    t.string   "remote_favicon_url",       limit: 255
    t.integer  "favicon_width",            limit: 4
    t.integer  "favicon_height",           limit: 4
    t.string   "favicon_content_type",     limit: 255
    t.integer  "favicon_file_size",        limit: 4
    t.integer  "projects_count",           limit: 4,     default: 0, null: false
    t.string   "Institution_Type",         limit: 255
    t.string   "provider",                 limit: 255
    t.string   "provider_id",              limit: 255
    t.text     "geocode_json",             limit: 65535
    t.float    "geocode_lat",              limit: 24
    t.float    "geocode_lng",              limit: 24
    t.string   "logo",                     limit: 255
    t.string   "remote_logo_url",          limit: 255
    t.integer  "logo_width",               limit: 4
    t.integer  "logo_height",              limit: 4
    t.string   "logo_content_type",        limit: 255
    t.integer  "logo_file_size",           limit: 4
    t.text     "wikipedia_summary",        limit: 65535
    t.string   "wikipedia_coords",         limit: 255
    t.string   "wikipedia_url",            limit: 255
  end

  add_index "schools", ["slug"], name: "index_schools_on_slug", unique: true, using: :btree

  create_table "suggesteds", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "work_id",      limit: 4,                   null: false
    t.integer  "author_id",    limit: 4,                   null: false
    t.string   "suggestion",   limit: 128
    t.boolean  "approved",     limit: 1,   default: false, null: false
    t.boolean  "open",         limit: 1,   default: true,  null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "suggester_ip", limit: 255
  end

  add_index "suggesteds", ["work_id"], name: "index_suggesteds_on_work_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "trigrams", force: :cascade do |t|
    t.string  "trigram",     limit: 3
    t.integer "score",       limit: 2
    t.integer "owner_id",    limit: 4
    t.string  "owner_type",  limit: 255
    t.string  "fuzzy_field", limit: 255
  end

  add_index "trigrams", ["owner_id", "owner_type", "fuzzy_field", "trigram", "score"], name: "index_for_match", using: :btree
  add_index "trigrams", ["owner_id", "owner_type"], name: "index_by_owner", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "email",                limit: 255,                 null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "password_digest",      limit: 255
    t.boolean  "admin",                limit: 1,   default: false
    t.string   "activation_digest",    limit: 255
    t.boolean  "activated",            limit: 1,   default: false
    t.datetime "activated_at"
    t.string   "remember_digest",      limit: 255
    t.integer  "school_id",            limit: 4
    t.boolean  "superman",             limit: 1,   default: false, null: false
    t.integer  "works_count",          limit: 4,   default: 0,     null: false
    t.integer  "bookmarks_count",      limit: 4,   default: 0,     null: false
    t.string   "reset_digest",         limit: 255
    t.datetime "reset_sent_at"
    t.string   "slug",                 limit: 255,                 null: false
    t.integer  "sign_in_count",        limit: 4
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   limit: 255
    t.string   "last_sign_in_ip",      limit: 255
    t.string   "uuid",                 limit: 255
    t.string   "nutshell",             limit: 255
    t.string   "avatar",               limit: 255
    t.string   "ed_level",             limit: 255
    t.string   "new_email",            limit: 255
    t.string   "email_update_digest",  limit: 255
    t.datetime "email_update_sent_at"
    t.boolean  "new_email_confirmed",  limit: 1,   default: false
    t.integer  "projects_count",       limit: 4,   default: 0,     null: false
    t.integer  "comments_count",       limit: 4,   default: 0,     null: false
    t.boolean  "has_oauth",            limit: 1,   default: false, null: false
    t.boolean  "created_as_oauth",     limit: 1,   default: false, null: false
    t.boolean  "has_password",         limit: 1,   default: true,  null: false
    t.integer  "affiliations_count",   limit: 4,   default: 0,     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "visits", force: :cascade do |t|
    t.uuid     "visitor_id",       limit: 16
    t.string   "ip",               limit: 255
    t.text     "user_agent",       limit: 65535
    t.text     "referrer",         limit: 65535
    t.text     "landing_page",     limit: 65535
    t.integer  "user_id",          limit: 4
    t.string   "referring_domain", limit: 255
    t.string   "search_keyword",   limit: 255
    t.string   "browser",          limit: 255
    t.string   "os",               limit: 255
    t.string   "device_type",      limit: 255
    t.integer  "screen_height",    limit: 4
    t.integer  "screen_width",     limit: 4
    t.string   "country",          limit: 255
    t.string   "region",           limit: 255
    t.string   "city",             limit: 255
    t.string   "postal_code",      limit: 255
    t.decimal  "latitude",                       precision: 10
    t.decimal  "longitude",                      precision: 10
    t.string   "utm_source",       limit: 255
    t.string   "utm_medium",       limit: 255
    t.string   "utm_term",         limit: 255
    t.string   "utm_content",      limit: 255
    t.string   "utm_campaign",     limit: 255
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

  create_table "works", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "document",             limit: 255
    t.integer  "user_id",              limit: 4,                        null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "school_id",            limit: 4
    t.string   "content_type",         limit: 255
    t.integer  "file_size",            limit: 4
    t.string   "file_name",            limit: 255
    t.float    "gradient_average",     limit: 24
    t.integer  "gradient_count",       limit: 4,        default: 0,     null: false
    t.text     "file_content_md",      limit: 16777215
    t.text     "file_content_html",    limit: 16777215
    t.integer  "gradient_average_rgb", limit: 4,        default: 0,     null: false
    t.boolean  "anonymouse",           limit: 1,        default: false, null: false
    t.string   "author_name",          limit: 255
    t.string   "school_name",          limit: 255
    t.text     "file_content_text",    limit: 16777215
    t.string   "slug",                 limit: 255,                      null: false
    t.string   "remote_document_url",  limit: 255
    t.string   "description",          limit: 255
    t.integer  "width",                limit: 4
    t.integer  "height",               limit: 4
    t.integer  "impressions_count",    limit: 4,        default: 0,     null: false
    t.string   "source_from",          limit: 255
    t.integer  "project_id",           limit: 4
    t.boolean  "is_latest_version",    limit: 1
    t.string   "project_name",         limit: 255
    t.text     "file_content_css",     limit: 16777215
    t.string   "alternate_link",       limit: 255
    t.integer  "revisions_count",      limit: 4,        default: 0,     null: false
    t.integer  "comments_count",       limit: 4,        default: 0,     null: false
  end

  add_index "works", ["project_id"], name: "index_works_on_project_id", using: :btree
  add_index "works", ["slug"], name: "index_works_on_slug", unique: true, using: :btree
  add_index "works", ["user_id", "created_at"], name: "index_works_on_user_id_and_created_at", using: :btree
  add_index "works", ["user_id"], name: "index_works_on_user_id", using: :btree

  add_foreign_key "affiliations", "schools"
  add_foreign_key "affiliations", "users"
  add_foreign_key "diffs", "projects"
  add_foreign_key "linked_accounts", "users"
  add_foreign_key "projects", "schools"
  add_foreign_key "projects", "users"
  add_foreign_key "revisions", "projects"
  add_foreign_key "revisions", "works"
  add_foreign_key "works", "projects"
end
