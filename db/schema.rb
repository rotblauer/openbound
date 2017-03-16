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

ActiveRecord::Schema.define(version: 20170316081030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.integer  "is_primary",       limit: 2,   default: 0, null: false
    t.integer  "is_assignment",    limit: 2,   default: 1, null: false
    t.integer  "is_preference",    limit: 2,   default: 0, null: false
    t.integer  "is_active",        limit: 2,   default: 1, null: false
    t.string   "concentration",    limit: 255
    t.integer  "graduated",        limit: 2
    t.integer  "is_fallback",      limit: 2
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "provider",         limit: 255
    t.string   "institution_type", limit: 255
    t.string   "year",             limit: 255
  end

  add_index "affiliations", ["school_id"], name: "public_affiliations_school_id1_idx", using: :btree
  add_index "affiliations", ["user_id"], name: "public_affiliations_user_id0_idx", using: :btree

  create_table "ahoy_events", force: :cascade do |t|
    t.binary   "visit_id"
    t.integer  "user_id"
    t.string   "name",       limit: 255
    t.text     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "public_ahoy_events_time2_idx", using: :btree
  add_index "ahoy_events", ["user_id"], name: "public_ahoy_events_user_id1_idx", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "public_ahoy_events_visit_id0_idx", using: :btree

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",                          null: false
    t.integer  "work_id",                          null: false
    t.integer  "bookmarked", limit: 2, default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "project_id"
  end

  add_index "bookmarks", ["project_id", "user_id"], name: "public_bookmarks_project_id3_idx", using: :btree
  add_index "bookmarks", ["project_id"], name: "public_bookmarks_project_id2_idx", using: :btree
  add_index "bookmarks", ["user_id", "work_id"], name: "public_bookmarks_user_id0_idx", unique: true, using: :btree
  add_index "bookmarks", ["work_id"], name: "public_bookmarks_work_id1_idx", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "work_id",    null: false
    t.text     "body",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id", null: false
  end

  add_index "comments", ["user_id"], name: "public_comments_user_id0_idx", using: :btree
  add_index "comments", ["work_id", "user_id"], name: "public_comments_work_id1_idx", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "diffs", force: :cascade do |t|
    t.integer  "work1",      null: false
    t.integer  "work2",      null: false
    t.integer  "project_id"
    t.text     "diff_md"
    t.text     "diff_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "diff_text"
    t.text     "left"
    t.text     "right"
    t.text     "right_text"
    t.text     "left_text"
  end

  add_index "diffs", ["project_id"], name: "public_diffs_project_id0_idx", using: :btree

  create_table "forkdestinations", force: :cascade do |t|
    t.integer  "forkable_id"
    t.string   "forkable_type",    limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "points_to"
    t.string   "points_to_name",   limit: 255
    t.string   "points_to_author", limit: 255
  end

  add_index "forkdestinations", ["forkable_type", "forkable_id"], name: "public_forkdestinations_forkable_type0_idx", using: :btree

  create_table "forkoriginations", force: :cascade do |t|
    t.integer  "forkable_id"
    t.string   "forkable_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "points_to"
  end

  add_index "forkoriginations", ["forkable_type", "forkable_id"], name: "public_forkoriginations_forkable_type0_idx", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "public_friendly_id_slugs_slug0_idx", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "public_friendly_id_slugs_slug1_idx", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "public_friendly_id_slugs_sluggable_id2_idx", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "public_friendly_id_slugs_sluggable_type3_idx", using: :btree

  create_table "gradients", force: :cascade do |t|
    t.integer  "grad",       null: false
    t.integer  "user_id",    null: false
    t.integer  "work_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "gradients", ["user_id", "work_id"], name: "public_gradients_user_id0_idx", unique: true, using: :btree
  add_index "gradients", ["work_id"], name: "public_gradients_work_id1_idx", using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name",     limit: 255
    t.string   "action_name",         limit: 255
    t.string   "view_name",           limit: 255
    t.string   "request_hash",        limit: 255
    t.string   "ip_address",          limit: 255
    t.string   "session_hash",        limit: 255
    t.string   "message",             limit: 255
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "public_impressions_controller_name0_idx", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "public_impressions_controller_name1_idx", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "public_impressions_controller_name2_idx", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "public_impressions_impressionable_type3_idx", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "public_impressions_impressionable_type4_idx", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "public_impressions_impressionable_type5_idx", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "public_impressions_impressionable_type6_idx", using: :btree
  add_index "impressions", ["user_id"], name: "public_impressions_user_id7_idx", using: :btree

  create_table "linked_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",            limit: 255
    t.string   "uid",                 limit: 255
    t.string   "name",                limit: 255
    t.string   "email",               limit: 255
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "image_url",           limit: 255
    t.string   "location",            limit: 255
    t.text     "oauth_info_json"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "oauth_raw_info_json"
    t.string   "accesstoken",         limit: 255
  end

  add_index "linked_accounts", ["provider", "uid"], name: "public_linked_accounts_provider2_idx", using: :btree
  add_index "linked_accounts", ["uid"], name: "public_linked_accounts_uid1_idx", using: :btree
  add_index "linked_accounts", ["user_id"], name: "public_linked_accounts_user_id0_idx", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.string   "author_name",       limit: 255
    t.text     "file_content_md"
    t.text     "file_content_html"
    t.text     "file_content_text"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "works_count",                   default: 0,  null: false
    t.integer  "is_public",         limit: 2,   default: 1,  null: false
    t.integer  "is_collaborative",  limit: 2,   default: 1,  null: false
    t.string   "name",              limit: 255
    t.string   "slug",              limit: 255
    t.integer  "recent_work_id"
    t.integer  "anonymouse",        limit: 2
    t.string   "school_name",       limit: 255
    t.integer  "impressions_count",             default: 0,  null: false
    t.integer  "bookmarks_count",               default: 0,  null: false
    t.string   "description",       limit: 255
    t.integer  "diffs_count",                   default: 0,  null: false
    t.integer  "comments_count",                default: 0,  null: false
    t.integer  "revisions_count",               default: 0,  null: false
    t.string   "tags",                          default: [],              array: true
  end

  add_index "projects", ["school_id"], name: "public_projects_school_id1_idx", using: :btree
  add_index "projects", ["tags"], name: "index_projects_on_tags", using: :gin
  add_index "projects", ["user_id"], name: "public_projects_user_id0_idx", using: :btree

  create_table "recommendeds", force: :cascade do |t|
    t.string   "work_id",    limit: 255, null: false
    t.string   "user_id",    limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "revisions", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "project_id"
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "revisions", ["project_id"], name: "public_revisions_project_id1_idx", using: :btree
  add_index "revisions", ["work_id"], name: "public_revisions_work_id0_idx", using: :btree

  create_table "schools", force: :cascade do |t|
    t.integer  "Institution_ID"
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
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "works_count",                          default: 0, null: false
    t.integer  "affiliations_count",                   default: 0, null: false
    t.string   "slug",                     limit: 255
    t.integer  "is_academic",              limit: 2
    t.string   "favicon",                  limit: 255
    t.string   "remote_favicon_url",       limit: 255
    t.integer  "favicon_width"
    t.integer  "favicon_height"
    t.string   "favicon_content_type",     limit: 255
    t.integer  "favicon_file_size"
    t.integer  "projects_count",                       default: 0, null: false
    t.string   "Institution_Type",         limit: 255
    t.string   "provider",                 limit: 255
    t.string   "provider_id",              limit: 255
    t.text     "geocode_json"
    t.float    "geocode_lat"
    t.float    "geocode_lng"
    t.string   "logo",                     limit: 255
    t.string   "remote_logo_url",          limit: 255
    t.integer  "logo_width"
    t.integer  "logo_height"
    t.string   "logo_content_type",        limit: 255
    t.integer  "logo_file_size"
    t.text     "wikipedia_summary"
    t.string   "wikipedia_coords",         limit: 255
    t.string   "wikipedia_url",            limit: 255
  end

  add_index "schools", ["slug"], name: "public_schools_slug0_idx", unique: true, using: :btree

  create_table "suggesteds", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "work_id",                              null: false
    t.integer  "author_id",                            null: false
    t.string   "suggestion",   limit: 128
    t.integer  "approved",     limit: 2,   default: 0, null: false
    t.integer  "open",         limit: 2,   default: 1, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "suggester_ip", limit: 255
  end

  add_index "suggesteds", ["work_id"], name: "public_suggesteds_work_id0_idx", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "public_taggings_tag_id0_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "public_taggings_taggable_id1_idx", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "public_tags_name0_idx", unique: true, using: :btree

  create_table "trigrams", force: :cascade do |t|
    t.string  "trigram",     limit: 3
    t.integer "score",       limit: 2
    t.integer "owner_id"
    t.string  "owner_type",  limit: 255
    t.string  "fuzzy_field", limit: 255
  end

  add_index "trigrams", ["owner_id", "owner_type", "fuzzy_field", "trigram", "score"], name: "public_trigrams_owner_id0_idx", using: :btree
  add_index "trigrams", ["owner_id", "owner_type"], name: "public_trigrams_owner_id1_idx", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "email",                limit: 255,             null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "password_digest",      limit: 255
    t.integer  "admin",                limit: 2,   default: 0
    t.string   "activation_digest",    limit: 255
    t.integer  "activated",            limit: 2,   default: 0
    t.datetime "activated_at"
    t.string   "remember_digest",      limit: 255
    t.integer  "school_id"
    t.integer  "superman",             limit: 2,   default: 0, null: false
    t.integer  "works_count",                      default: 0, null: false
    t.integer  "bookmarks_count",                  default: 0, null: false
    t.string   "reset_digest",         limit: 255
    t.datetime "reset_sent_at"
    t.string   "slug",                 limit: 255,             null: false
    t.integer  "sign_in_count"
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
    t.integer  "new_email_confirmed",  limit: 2,   default: 0
    t.integer  "projects_count",                   default: 0, null: false
    t.integer  "comments_count",                   default: 0, null: false
    t.integer  "has_oauth",            limit: 2,   default: 0, null: false
    t.integer  "created_as_oauth",     limit: 2,   default: 0, null: false
    t.integer  "has_password",         limit: 2,   default: 1, null: false
    t.integer  "affiliations_count",               default: 0, null: false
  end

  add_index "users", ["email"], name: "public_users_email0_idx", unique: true, using: :btree
  add_index "users", ["slug"], name: "public_users_slug1_idx", unique: true, using: :btree

  create_table "visits", force: :cascade do |t|
    t.binary   "visitor_id"
    t.string   "ip",               limit: 255
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain", limit: 255
    t.string   "search_keyword",   limit: 255
    t.string   "browser",          limit: 255
    t.string   "os",               limit: 255
    t.string   "device_type",      limit: 255
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country",          limit: 255
    t.string   "region",           limit: 255
    t.string   "city",             limit: 255
    t.string   "postal_code",      limit: 255
    t.decimal  "latitude",                     precision: 10
    t.decimal  "longitude",                    precision: 10
    t.string   "utm_source",       limit: 255
    t.string   "utm_medium",       limit: 255
    t.string   "utm_term",         limit: 255
    t.string   "utm_content",      limit: 255
    t.string   "utm_campaign",     limit: 255
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "public_visits_user_id0_idx", using: :btree

  create_table "works", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "document",             limit: 255
    t.integer  "user_id",                                       null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "school_id"
    t.string   "content_type",         limit: 255
    t.integer  "file_size"
    t.string   "file_name",            limit: 255
    t.float    "gradient_average"
    t.integer  "gradient_count",                   default: 0,  null: false
    t.text     "file_content_md"
    t.text     "file_content_html"
    t.integer  "gradient_average_rgb",             default: 0,  null: false
    t.integer  "anonymouse",           limit: 2,   default: 0,  null: false
    t.string   "author_name",          limit: 255
    t.string   "school_name",          limit: 255
    t.text     "file_content_text"
    t.string   "slug",                 limit: 255
    t.string   "remote_document_url",  limit: 255
    t.string   "description",          limit: 255
    t.integer  "width"
    t.integer  "height"
    t.integer  "impressions_count",                default: 0,  null: false
    t.string   "source_from",          limit: 255
    t.integer  "project_id"
    t.integer  "is_latest_version",    limit: 2
    t.string   "project_name",         limit: 255
    t.text     "file_content_css"
    t.string   "alternate_link",       limit: 255
    t.integer  "revisions_count",                  default: 0,  null: false
    t.integer  "comments_count",                   default: 0,  null: false
    t.string   "tags",                             default: [],              array: true
  end

  add_index "works", ["project_id"], name: "public_works_project_id3_idx", using: :btree
  add_index "works", ["slug"], name: "public_works_slug0_idx", unique: true, using: :btree
  add_index "works", ["tags"], name: "index_works_on_tags", using: :gin
  add_index "works", ["user_id", "created_at"], name: "public_works_user_id1_idx", using: :btree
  add_index "works", ["user_id"], name: "public_works_user_id2_idx", using: :btree

  add_foreign_key "affiliations", "schools", name: "affiliations_school_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "affiliations", "users", name: "affiliations_user_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "diffs", "projects", name: "diffs_project_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "linked_accounts", "users", name: "linked_accounts_user_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "projects", "schools", name: "projects_school_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "projects", "users", name: "projects_user_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "revisions", "projects", name: "revisions_project_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "revisions", "works", name: "revisions_work_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "works", "projects", name: "works_project_id_fkey", on_update: :restrict, on_delete: :restrict
end
