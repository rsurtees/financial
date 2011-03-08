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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110223021550) do

  create_table "budgets", :force => true do |t|
    t.string   "description", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "current_years", :force => true do |t|
    t.integer  "year",       :limit => 4, :default => 2010
    t.integer  "first_week", :limit => 1, :default => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donations", :force => true do |t|
    t.float    "amount"
    t.integer  "user_id"
    t.integer  "weekdate_id"
    t.integer  "budget_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pledges", :force => true do |t|
    t.float    "amount"
    t.string   "freq",       :limit => 20
    t.float    "amount2"
    t.string   "freq2",      :limit => 20
    t.float    "pledge_09",                :default => 0.0
    t.float    "pledge_10",                :default => 0.0
    t.float    "pledge_11",                :default => 0.0
    t.float    "pledge_12",                :default => 0.0
    t.float    "pledge_13",                :default => 0.0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first",      :limit => 50
    t.string   "surname",    :limit => 50
    t.string   "street",     :limit => 50
    t.string   "po_box",     :limit => 50
    t.string   "town",       :limit => 50
    t.string   "state",      :limit => 50
    t.string   "zip",        :limit => 5
    t.string   "email",      :limit => 50
    t.boolean  "status"
    t.integer  "pledge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weekdates", :force => true do |t|
    t.integer  "qmw",         :limit => 3,  :default => 111
    t.integer  "year",        :limit => 5,  :default => 2009
    t.integer  "quarter",     :limit => 2,  :default => 1
    t.integer  "month",       :limit => 2,  :default => 1
    t.integer  "day",         :limit => 2,  :default => 1
    t.integer  "week",        :limit => 2,  :default => 1
    t.string   "date_string", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
