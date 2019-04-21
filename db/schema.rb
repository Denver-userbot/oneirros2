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

ActiveRecord::Schema.define(version: 2019_04_18_132629) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "oneirros_companies", force: :cascade do |t|
    t.string "name"
  end

  create_table "oneirros_companies_rival_factories", id: false, force: :cascade do |t|
    t.bigint "rival_factory_id", null: false
    t.bigint "oneirros_company_id", null: false
  end

  create_table "rival_factories", id: false, force: :cascade do |t|
    t.bigint "rivals_factory_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rival_factories_resources", id: false, force: :cascade do |t|
    t.bigint "rival_factory_id", null: false
    t.bigint "rival_resource_id", null: false
  end

  create_table "rival_regions", force: :cascade do |t|
    t.bigint "rivals_id"
    t.string "name_ru"
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rival_resources", id: :bigint, default: -> { "nextval('rival_ressources_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "rivals_resource_id"
    t.string "name"
  end

end
