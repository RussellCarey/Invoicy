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

ActiveRecord::Schema[7.0].define(version: 2022_08_18_051329) do
  create_table "clients", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.integer "phone_number"
    t.text "note"
    t.boolean "is_active"
    t.integer "address_number"
    t.string "address_city"
    t.string "address_street"
    t.string "address_county"
    t.string "address_postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "details", limit: 50, null: false
    t.float "amount", null: false
    t.float "price", null: false
    t.float "total", null: false
    t.integer "invoice_id"
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.datetime "issue_date", default: "2022-08-12 09:05:07", null: false
    t.datetime "due_date", null: false
    t.datetime "last_send_date"
    t.integer "status", default: 0, null: false
    t.integer "discount", default: 0, null: false
    t.float "tax", default: 0.0, null: false
    t.integer "client_id", null: false
    t.float "total"
    t.float "pre_total"
    t.datetime "paid_date"
    t.integer "user_id", default: 0, null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "phone_number"
    t.string "company_name"
    t.integer "address_number"
    t.string "address_street"
    t.string "address_city"
    t.string "address_county"
    t.string "address_postcode"
    t.boolean "is_admin"
    t.integer "credits", default: 0
    t.boolean "is_member", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "clients", "users"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "clients"
end
