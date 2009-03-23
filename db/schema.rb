# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090323040211) do

  create_table "cached_pages", :force => true do |t|
    t.string   "url"
    t.text     "content",    :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cached_pages", ["url"], :name => "index_cached_pages_on_url"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type", "created_at"], :name => "commentable_poly"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "domain_usages", :force => true do |t|
    t.integer  "domain_id"
    t.string   "usage_type"
    t.integer  "usage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domain_usages", ["domain_id", "usage_id", "usage_type"], :name => "domain_usages_ids", :unique => true

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.text     "variations"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domains", ["name"], :name => "index_domains_on_name", :unique => true

  create_table "favorites", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.integer  "favoritable_id",   :null => false
    t.string   "favoritable_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["favoritable_id"], :name => "index_favorites_on_favoritable_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "invitation_requests", :force => true do |t|
    t.integer  "invitation_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitation_requests", ["email"], :name => "index_invitation_requests_on_email"
  add_index "invitation_requests", ["invitation_id"], :name => "index_invitation_requests_on_invitation_id"

  create_table "invitations", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.integer  "usages"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["code"], :name => "index_invitations_on_code", :unique => true
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "parselets", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "code"
    t.string   "pattern"
    t.string   "example_url"
    t.string   "domain_id"
    t.integer  "user_id"
    t.integer  "version",        :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "checked_at"
    t.boolean  "works",          :default => false
    t.integer  "cached_page_id"
    t.integer  "ratings_count",  :default => 0,     :null => false
    t.integer  "comments_count", :default => 0,     :null => false
    t.integer  "cached_rating",  :default => 0,     :null => false
    t.text     "signature"
    t.boolean  "best_version",   :default => false
    t.float    "score",          :default => 0.0
  end

  add_index "parselets", ["cached_page_id"], :name => "index_parselets_on_cached_page_id"
  add_index "parselets", ["domain_id"], :name => "index_parselets_on_domain_id"
  add_index "parselets", ["name"], :name => "index_parselets_on_name"
  add_index "parselets", ["user_id"], :name => "index_parselets_on_user_id"

  create_table "password_requests", :force => true do |t|
    t.string   "email"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "password_requests", ["email"], :name => "index_password_requests_on_email"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.integer  "ratable_id"
    t.string   "ratable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["ratable_id", "ratable_type"], :name => "index_ratings_on_ratable_id_and_ratable_type"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "sprig_usages", :force => true do |t|
    t.integer  "sprig_id"
    t.integer  "sprig_version_id"
    t.integer  "parselet_id"
    t.integer  "parselet_version_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sprig_usages", ["sprig_id", "sprig_version_id", "parselet_id", "parselet_version_id"], :name => "sprig_usages_ids", :unique => true

  create_table "sprig_versions", :force => true do |t|
    t.integer  "sprig_id"
    t.integer  "version"
    t.string   "name"
    t.text     "description"
    t.text     "code"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "updated_at"
  end

  add_index "sprig_versions", ["name"], :name => "index_sprig_versions_on_name"
  add_index "sprig_versions", ["sprig_id", "version"], :name => "index_sprig_versions_on_sprig_id_and_version", :unique => true
  add_index "sprig_versions", ["user_id"], :name => "index_sprig_versions_on_user_id"

  create_table "sprigs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "code"
    t.integer  "user_id"
    t.integer  "version"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sprigs", ["name"], :name => "index_sprigs_on_name"
  add_index "sprigs", ["user_id"], :name => "index_sprigs_on_user_id"

  create_table "thumbnails", :force => true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tries"
  end

  add_index "thumbnails", ["url"], :name => "index_thumbnails_on_url", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.boolean  "admin",                                    :default => false
    t.integer  "invitation_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
