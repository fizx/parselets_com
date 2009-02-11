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

ActiveRecord::Schema.define(:version => 20090209053526) do

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.text     "variations"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parselets", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "code"
    t.string   "pattern"
    t.string   "example_url"
    t.string   "domain_id"
    t.integer  "user_id"
    t.integer  "version"
    t.boolean  "pattern_regex"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sprig_usages", :force => true do |t|
    t.integer  "sprig_id"
    t.integer  "sprig_version_id"
    t.integer  "parselet_id"
    t.integer  "parselet_version_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end