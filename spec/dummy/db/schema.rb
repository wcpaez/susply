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

ActiveRecord::Schema.define(version: 20150521222634) do

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "subdomain"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "susply_payments", force: :cascade do |t|
    t.integer  "owner_id"
    t.integer  "plan_id"
    t.integer  "subscription_id"
    t.integer  "amount"
    t.datetime "period_start"
    t.datetime "period_end"
    t.string   "status"
    t.string   "invoice"
    t.string   "generated_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "susply_payments", ["owner_id"], name: "index_susply_payments_on_owner_id"

  create_table "susply_plans", force: :cascade do |t|
    t.string   "sku"
    t.string   "name"
    t.string   "description"
    t.integer  "price"
    t.string   "interval"
    t.boolean  "highlight"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "active"
    t.boolean  "published"
  end

  create_table "susply_subscriptions", force: :cascade do |t|
    t.integer  "owner_id"
    t.integer  "plan_id"
    t.datetime "start"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.integer  "quantity"
    t.datetime "deactivated_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "susply_subscriptions", ["owner_id"], name: "index_susply_subscriptions_on_owner_id"

end
