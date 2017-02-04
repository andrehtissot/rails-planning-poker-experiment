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

ActiveRecord::Schema.define(version: 20140918233452) do

  create_table "access_logs", force: true do |t|
    t.text     "header_json",  limit: 2147483647
    t.text     "session_json", limit: 2147483647
    t.string   "controller"
    t.string   "action"
    t.text     "params",       limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "browser_logs", force: true do |t|
    t.text     "header_json",   limit: 2147483647
    t.text     "event_json",    limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "access_log_id", limit: 16777215
  end

  create_table "competences", force: true do |t|
    t.integer  "participant_id"
    t.string   "title"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "competences", ["deleted_at"], name: "index_competences_on_deleted_at", using: :btree
  add_index "competences", ["participant_id"], name: "index_competences_on_participant_id", using: :btree

  create_table "estimates", force: true do |t|
    t.integer  "team_id"
    t.integer  "requirement_id"
    t.float    "effort_estimate", limit: 24
    t.text     "justification"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "estimates", ["deleted_at"], name: "index_estimates_on_deleted_at", using: :btree
  add_index "estimates", ["requirement_id"], name: "index_estimates_on_requirement_id", using: :btree
  add_index "estimates", ["team_id"], name: "index_estimates_on_team_id", using: :btree

  create_table "participants", force: true do |t|
    t.string   "name"
    t.date     "birthday"
    t.string   "function"
    t.integer  "sex"
    t.integer  "original_participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "participants", ["deleted_at"], name: "index_participants_on_deleted_at", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.string   "hashkey"
    t.string   "objective"
    t.string   "technologies"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "projects", ["deleted_at"], name: "index_projects_on_deleted_at", using: :btree

  create_table "requirements", force: true do |t|
    t.integer  "project_id"
    t.string   "hashkey"
    t.float    "relative_starting_point", limit: 24
    t.float    "relative_completeness",   limit: 24
    t.text     "description"
    t.float    "real_estimate",           limit: 24
    t.float    "real_effort",             limit: 24
    t.boolean  "for_experiment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "requirements", ["deleted_at"], name: "index_requirements_on_deleted_at", using: :btree
  add_index "requirements", ["project_id"], name: "index_requirements_on_project_id", using: :btree

  create_table "round_participants", force: true do |t|
    t.integer  "participant_id"
    t.integer  "round_id"
    t.float    "effort_estimate", limit: 24
    t.string   "justification"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "round_participants", ["deleted_at"], name: "index_round_participants_on_deleted_at", using: :btree
  add_index "round_participants", ["participant_id"], name: "index_round_participants_on_participant_id", using: :btree
  add_index "round_participants", ["round_id"], name: "index_round_participants_on_round_id", using: :btree

  create_table "rounds", force: true do |t|
    t.integer  "estimate_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "rounds", ["deleted_at"], name: "index_rounds_on_deleted_at", using: :btree
  add_index "rounds", ["estimate_id"], name: "index_rounds_on_estimate_id", using: :btree

  create_table "team_participants", force: true do |t|
    t.integer  "participant_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "team_participants", ["deleted_at"], name: "index_team_participants_on_deleted_at", using: :btree
  add_index "team_participants", ["participant_id"], name: "index_team_participants_on_participant_id", using: :btree
  add_index "team_participants", ["team_id"], name: "index_team_participants_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["deleted_at"], name: "index_teams_on_deleted_at", using: :btree

end
