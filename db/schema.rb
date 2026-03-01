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

ActiveRecord::Schema[8.0].define(version: 2026_03_01_112616) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id", "name"], name: "index_categories_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_items_on_name", unique: true
  end

  create_table "list_items", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.bigint "item_id", null: false
    t.integer "quantity"
    t.integer "position"
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_list_items_on_item_id"
    t.index ["list_id", "item_id"], name: "index_list_items_on_list_id_and_item_id", unique: true
    t.index ["list_id"], name: "index_list_items_on_list_id"
  end

  create_table "list_template_items", force: :cascade do |t|
    t.string "name"
    t.bigint "list_template_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_template_id"], name: "index_list_template_items_on_list_template_id"
  end

  create_table "list_templates", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.boolean "is_initial", default: false, null: false
    t.integer "list_template_items_count", default: 0, null: false
    t.integer "repeat_type", default: 0, null: false
    t.integer "repeat_days", default: 0, null: false
    t.index ["category_id"], name: "index_list_templates_on_category_id"
    t.index ["is_initial"], name: "index_list_templates_on_is_initial"
    t.index ["user_id", "title"], name: "index_list_templates_on_user_id_and_title"
    t.index ["user_id"], name: "index_list_templates_on_user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.integer "status", default: 0, null: false
    t.boolean "priority", default: false, null: false
    t.datetime "last_used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.bigint "category_id"
    t.integer "list_items_count", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "reminded_at"
    t.datetime "started_notification_at"
    t.bigint "list_template_id"
    t.date "target_date"
    t.index ["category_id"], name: "index_lists_on_category_id"
    t.index ["last_used_at"], name: "index_lists_on_last_used_at"
    t.index ["list_template_id", "target_date"], name: "index_lists_on_template_and_date_unique", unique: true, where: "(list_template_id IS NOT NULL)"
    t.index ["list_template_id"], name: "index_lists_on_list_template_id"
    t.index ["scheduled_at"], name: "index_lists_on_scheduled_at"
    t.index ["status"], name: "index_lists_on_status"
    t.index ["user_id", "priority"], name: "index_lists_on_user_id_and_priority"
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "list_id", null: false
    t.integer "kind", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_notifications_on_kind"
    t.index ["list_id"], name: "index_notifications_on_list_id"
    t.index ["user_id", "list_id", "kind"], name: "index_notifications_on_user_list_kind_unique", unique: true
    t.index ["user_id", "read_at"], name: "index_notifications_on_user_id_and_read_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "guest", default: false, null: false
    t.datetime "guest_created_at"
    t.string "provider"
    t.string "uid"
    t.boolean "notifications_enabled", default: true, null: false
    t.boolean "reminder_enabled", default: true, null: false
    t.integer "reminder_days_before", default: 1
    t.integer "notification_hour", default: 20
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["guest", "guest_created_at"], name: "index_users_on_guest_and_guest_created_at"
    t.index ["guest"], name: "index_users_on_guest"
    t.index ["guest_created_at"], name: "index_users_on_guest_created_at"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "categories", "users"
  add_foreign_key "list_items", "items"
  add_foreign_key "list_items", "lists"
  add_foreign_key "list_template_items", "list_templates"
  add_foreign_key "list_templates", "categories"
  add_foreign_key "list_templates", "users"
  add_foreign_key "lists", "categories"
  add_foreign_key "lists", "list_templates"
  add_foreign_key "lists", "users"
  add_foreign_key "notifications", "lists"
  add_foreign_key "notifications", "users"
end
