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

ActiveRecord::Schema.define(version: 20170326235338) do

  create_table "common_terms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "search_term"
    t.integer  "pages"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "search_result_pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "search_term", limit: 128,                   null: false
    t.integer  "page",                      default: 1,     null: false
    t.text     "content",     limit: 65535
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "last_page",                 default: false
    t.index ["search_term", "page", "updated_at"], name: "index_search_result_pages_on_search_term_and_page_and_updated_at", using: :btree
    t.index ["updated_at"], name: "index_search_result_pages_on_updated_at", using: :btree
  end

end
