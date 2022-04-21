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

ActiveRecord::Schema.define(version: 2022_04_20_171242) do

  create_table "githubs", force: :cascade do |t|
    t.string "project"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_githubs_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "eth_message"
    t.string "eth_address"
    t.string "eth_signature"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "eth_address"
    t.string "eth_nonce"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "eth_checksum"
  end

  create_table "widgets", force: :cascade do |t|
    t.boolean "mirror"
    t.boolean "nfts"
    t.boolean "projects"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_widgets_on_user_id"
  end

  add_foreign_key "githubs", "users"
  add_foreign_key "widgets", "users"
end
